# Serialize Backbone.Model.save
[![Build Status](https://travis-ci.org/flinto/serialize_backbone_model.png)](https://travis-ci.org/flinto/serialize_backbone_model)

This is a small bit of JavaScript code that prevents `Backbone.Model.save()` from creating AJAX requests out of order, by queuing its requests.

## Why and when you need this?

Use this if you are making a web site that saves a Backbone model frequently in short amount of time. For example, if you have a model that saves x/y coordinates on screen whenever your user moves an instance of the model, but one of your server instance takes time to respond, you will ended up saving wrong result.

1. A user moves an instance to (100, 100), which makes first AJAX call (which goes to server instance 1)
1. The user immediately moves same instance (105, 100), which makes second call immediately (which goes to server instance 2)

If somehow server instance 1 has high load and takes 500ms to handle the data while server instance 2 only takes 50ms, instance 2 saves `{X:105, Y:100}` first, then server instance 1 saves `{x:100, y:100}` later, even though final result should be `{x:100, y:100}`.

## Incompatibility and Notes

This module is intended to solve particular issues we have at Flinto. Thus, there are couple of things you need to know before you use it.

This module doesn't work if your code expects and relies on `Backbone.Model.save` returning `jqXHR`. If requests get queued, it return `null` instead of `jqXHR`. It still returns `false` if validation fails.

Despite its name, this module doesn't actually queue and serialize all requests. If you make 3 requests on same instance of same model within a very short amount of time, this module will skip the second request so it only sends requests twice. (the first one and the last one.) This should work in most cases, except if you want to keep tracking all movement (such as implementing an undo feature.)

## Further reading

There are couple of projects that do similar things with a different approach.

##### jQuery plugin for serializing all AJAX requests
  http://blog.alexmaccaw.com/queuing-ajax-requests

Works with regular $.ajax method.



