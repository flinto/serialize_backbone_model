#
# Ref #740: https://github.com/flinto/flinto/issues/740
#
#  overwrite save method of Backbome.Model to serialize request to avoid
# the requests are processed out of order on server
#
Backbone.Model.prototype.original_save = Backbone.Model.prototype.save

Backbone.Model.prototype.save = (key, val, options) ->
  @_requestQueue = [] if !@_requestQueue
  @_requestQueue.push {key:key, val:val, options:options}
  if @_requestQueue.length > 1
    return null

  # Handle both `"key", value` and `{key: value}` -style arguments.
  options = val if (key == null || typeof key == 'object')

  options = {} if !options
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
  val = options if (key == null || typeof key == 'object')

  @original_save(key, val, options)