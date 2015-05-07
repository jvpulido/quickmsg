#!/usr/bin/env python

import sys
import json
import numpy as np
import time

sys.path.append('../../build')
sys.path.append('../../build/swig')
import quickmsg_py

class SubscriberImpl(quickmsg_py.AsyncSubscriber):
    def __init__(self, *args, **kwargs):
        super(SubscriberImpl, self).__init__(*args, **kwargs)

    def subscriber_impl(self, msg):
        print 'Python inherited subscriber callback'
        # msg=json.loads(msg)
        print 'got message', msg.msg

    # def handle_message(self, msg):
    #     print 'Python inherited subscriber shared ptr callback'
    #     print dir(msg)
    #     print msg.msg

if __name__=='__main__':
    s = SubscriberImpl('chatter')
    s.spin()
    

