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
msg['Subject'] = "Server is awake"
msg.attach(MIMEText(sys.argv[1]))

with smtplib.SMTP('smtp.gmail.com', 587) as mail:
    mail.ehlo()
    mail.starttls()
    mail.login(from_mail, mail_password)
    mail.send_message(msg)
    mail.close()