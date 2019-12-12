import sys
from mymail import MailCls
from params import from_mail, to_mail, mail_password

mymail = MailCls(from_mail, to_mail, mail_password, subject="Server is awake", content=sys.argv[1])
mymail.send_mail()