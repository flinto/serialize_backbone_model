
history = []
secondSaveCalled = false

Backbone.sync = (method, model, options) ->
  setTimeout () =>
    console.log 'timedout'
    history.push model.val
    options.success(model, {}, options)
  , 100


Backbone.Model.prototype.stored_saved_method = Backbone.Model.prototype.original_save

Backbone.Model.prototype.original_save = (key, val, options) ->
  test "always have option", () =>
    console.log key, val, options
    ok options != null, "Always have options"
    ok typeof val != 'undefined', "Always have options"
  @stored_saved_method(key, val, options)

Backbone.Model.prototype.stored_destroy_method = Backbone.Model.prototype.original_destroy

Backbone.Model.prototype.original_destroy = (options) ->
  options.success('callback')
  @destroyed = true

class TestModel extends Backbone.Model
  initialize: ->
    @destroyed = false
    #


m = new TestModel
m.set('val', 100)
m.save {}, success: () ->
  test "First value saved", () =>
    ok history.length == 1, "First call is saved"

    m.save {val:200}, success: () -> secondSaveCalled = true

    test "Save method should set value", () =>
      console.log m.val
      ok m.get('val') == 200, "Save method should set new value"

    m.save(val:250)

    m.set('val', 300)
    m.save {}, success: () ->
      test "Third call is saved", () =>
        ok secondSaveCalled == false, "Second call never executed"
        ok history.length == 2, "Call 2 times"

        m.save(val:400)

        setTimeout () =>
          test "Fourth call is saved", () =>
            ok secondSaveCalled == false, "Second call never executed"
            ok history.length == 3, "Call 3 times"
            ok typeof m.get('id') == 'undefined', 'Model id is not set'

          test "delay destroy method", () =>
            m.destroy success: (ret) =>
              test "destroy callback called", () =>
                ok ret == 'callback', "callback is called"

            ok m.destroyed == false, 'destroy method hasn\'t called'
            m.set('id', 1)
            setTimeout () =>
              test "destroy method called", () =>
                ok m.destroyed, 'destroy method has been called'
            , 100
        , 200

