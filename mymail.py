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

class MailCls():
    def __init__(self, from_mail, to_mail, password, subject='dlserver log.csv!', content=None):
        self.msg = MIMEMultipart()
        self.from_mail=from_mail
        self.to_mail=to_mail
        self.password=password

        self.msg['From']=self.from_mail
        self.msg['To']=self.to_mail
        self.msg['Subject']=subject
        if content is not None:
            self.msg.attach(MIMEText(content))

    def attach(self, folder_path, filename):
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
        self.msg.attach(attachment)

    def attach_all(self, folder_path):
        entries = listdir(folder_path)
        for entry in entries:
            self.attach(folder_path, entry)

    def send_mail(self):
        with smtplib.SMTP('smtp.gmail.com', 587) as mail:
            mail.ehlo()
            mail.starttls()
            mail.login(self.from_mail, self.password)
            mail.send_message(self.msg)
            mail.close()