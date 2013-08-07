
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

class TestModel extends Backbone.Model
  initialize: ->
    #


m = new TestModel
m.val = 100
m.save {}, success: () ->
  test "First value saved", () =>
    ok history.length == 1, "First call is saved"

    m.val = 200
    m.save {}, success: () -> secondSaveCalled = true

    m.val = 250
    m.save()

    m.val = 300
    m.save {}, success: () ->
      test "Third call is saved", () =>
        ok secondSaveCalled == false, "Second call never executed"
        ok history.length == 2, "Call 2 times"

        m.val = 400
        m.save()

        setTimeout () =>
          test "Fourth call is saved", () =>
            ok secondSaveCalled == false, "Second call never executed"
            ok history.length == 3, "Call 3 times"
        , 200

