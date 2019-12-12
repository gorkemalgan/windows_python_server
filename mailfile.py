import sys
from mymail import MailCls
from params import from_mail, to_mail, mail_password

pos = sys.argv[1].rfind('\\')
folder_path = sys.argv[1][:pos+1]
file_path = sys.argv[1][pos+1:]

mymail = MailCls(from_mail, to_mail, mail_password, subject='dlserver run logs!')
mymail.attach(folder_path, file_path)
if len(sys.argv) == 3:
    print(sys.argv[2])
    mymail.attach_all(sys.argv[2])
mymail.send_mail()