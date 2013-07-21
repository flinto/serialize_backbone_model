# Serialize Backbone.Model.save

This is a small JavaScript code that prevents `Backbone.Model.save()` creates AJAX requests out of order, by queuing its requests.

## Why and when you need this?

If you are making a web site that saves your model frequently in short amount of time, for example, you have a model that has x/y coordinates on screen and whenever your user moves an instance of the model but one of your server instance takes time to respond, you will ended up saving wrong result.

1. A user moves an instance to (100, 100), which makes first AJAX call (which goes to serer instance 1)
1. The user immediately moves same instance (105, 100), makes second call immediately (which goes to server instance 2)

If somehow server instance 1 have high load and takes 500ms to handle the data while server insntance 2 only takes 50ms, instance 2 saves `{X:105, Y:100}` first, then server instance 1 saves `{x:100, y:100}` later, even though final result should be `{x:100, y:100}`.

## What this model doesn't do

Despite of its name, this module doesn't exactly queuing and serializing all requests. For example, if you quickly make 3 requests on same instance of same model, this module will skip second call so it only sends requests twice. (1st one and 3rd one.) This should work most of case, except you want to keep tracking all movement. (such as implementing undo feature.)

## Further reading

There are similar project that does same thing with different approach.

##### jQuery plugin for serializing all AJAX request
  http://blog.alexmaccaw.com/queuing-ajax-requests

Works with regular $.ajax method.



