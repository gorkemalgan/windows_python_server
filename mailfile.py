import sys
from os.path import exists
from os import listdir
import smtplib
import mimetypes
from email import encoders
from email.message import EmailMessage
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.text import MIMEText
from params import from_mail, to_mail, mail_password

MAIL_TXT = 'mail.txt'
LOG_TXT = 'log.txt'

msg = MIMEMultipart()
msg['From']=from_mail
msg['To']=to_mail
msg['Subject']='dlserver run logs!'

def attach(folder_path, filename):
    file2send = folder_path + filename
    ctype, encoding = mimetypes.guess_type(file2send)
    if ctype is None or encoding is not None:
        ctype = "application/octet-stream"
    maintype, subtype = ctype.split("/",1)

    if maintype == "text":
        fp = open(file2send)
        attachment = MIMEText(fp.read(), _subtype=subtype)
    elif maintype == "image":
        fp = open(file2send, "rb")
        attachment = MIMEImage(fp.read(), _subtype=subtype)
    else:
        fp = open(file2send, "rb")
        attachment = MIMEBase(maintype, subtype)
        attachment.set_payload(fp.read())
        encoders.encode_base64(attachment)
    
    fp.close()
    attachment.add_header("Content-Disposition", "attachment", filename=filename)
    msg.attach(attachment)

def send_mail(msg):
    with smtplib.SMTP('smtp.gmail.com', 587) as mail:
        mail.ehlo()
        mail.starttls()
        mail.login(from_mail, mail_password)
        mail.send_message(msg)
        mail.close()

pos = sys.argv[1].rfind('\\')
folder_path = sys.argv[1][:pos+1]
file_path = sys.argv[1][pos+1:]

attach(folder_path, file_path)
send_mail(msg)