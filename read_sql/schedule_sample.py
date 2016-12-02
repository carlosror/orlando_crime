import threading;

def thread1(): 
  threading.Timer(2.0, thread1).start (); 
  print "stackoverflow";


def thread2():
  threading.Timer(5.0, thread2).start()
  print "Hello, World!"

thread1()
thread2()
