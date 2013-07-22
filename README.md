# Serialize Backbone.Model.save
[![Build Status](https://travis-ci.org/flinto/serialize_backbone_model.png)](https://travis-ci.org/flinto/serialize_backbone_model)

This is a small JavaScript code that prevents `Backbone.Model.save()` creates AJAX requests out of order, by queuing its requests.

## Why and when you need this?

If you are making a web site that saves your model frequently in short amount of time, for example, you have a model that has x/y coordinates on screen and whenever your user moves an instance of the model but one of your server instance takes time to respond, you will ended up saving wrong result.

1. A user moves an instance to (100, 100), which makes first AJAX call (which goes to serer instance 1)
1. The user immediately moves same instance (105, 100), makes second call immediately (which goes to server instance 2)

If somehow server instance 1 have high load and takes 500ms to handle the data while server instance 2 only takes 50ms, instance 2 saves `{X:105, Y:100}` first, then server instance 1 saves `{x:100, y:100}` later, even though final result should be `{x:100, y:100}`.

## Incompatibility and Notes

This module is intended to solve particular issues we have at Flinto. Thus, there are couple of things you need to know before you use it.

This module doesn't work if your code expects and relies on that `Backbone.Model.save` returns `jqXHR`. If request gets queued, it return `null` instead of `jqXHR`. It still returns `false` if validation fails.

Despite of its name, this module doesn't actually queuing and serializing all requests. If you make 3 requests on same instance of same model within very short amount of time, this module will skip the second request so it only sends requests twice. (the first one and the last one.) This should work most of case, except you want to keep tracking all movement. (such as implementing undo feature.)

## Further reading

There are couple of projects that does similar thing with different approach.

##### jQuery plugin for serializing all AJAX request
  http://blog.alexmaccaw.com/queuing-ajax-requests

Works with regular $.ajax method.



