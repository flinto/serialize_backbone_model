#
# Ref #740:
#
#  overwrite save method of Backbome.Model to serialize request to avoid
# the requests are processed out of order on server
#
Backbone.Model.prototype.original_save = Backbone.Model.prototype.save

Backbone.Model.prototype.save = (key, val, options) ->
  @_requestQueue = [] if !@_requestQueue
  @_requestQueue.push {key:key, val:val, options:options}

  attrs = @attributes
  # Handle both `"key", value` and `{key: value}` -style arguments.
  if (key == null || typeof key == 'undefined' || typeof key == 'object')
    attrs = key
    options = val
  else
    (attrs = {})[key] = val

  options = {} if !options

  # If we're not waiting and attributes exist, save acts as `set(attr).save(null, opts)`.
  return false if (attrs && (!options || !options.wait) && !@set(attrs, options))

  if @_requestQueue.length > 1
    return false

  success = options.success
  error   = options.error

  dequeue = () =>
    param = _.last(@_requestQueue)
    length = @_requestQueue.length
    @_requestQueue = []
    @save(param.key, param.val, param.options) if length > 1

  options.success = (model, resp, options) ->
    success(model, resp, options) if success
    dequeue()
  options.error = (model, resp, options) ->
    error(model, resp, options) if error
    dequeue()

  # Set back `options` to `val` to handle `{key: value}` style
  val = options if (key == null || typeof key == 'undefined' || typeof key == 'object')

  @original_save(key, val, options)