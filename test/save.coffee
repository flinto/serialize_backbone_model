
history = []
secondSaveCalled = false

Backbone.sync = (method, model, options) ->
  setTimeout () =>
    console.log 'timedout'
    history.push model.val
    options.success(model, {}, options)
  , 100


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


    m.val = 300
    m.save {}, success: () ->
      test "Third call is saved", () =>
        ok secondSaveCalled == false, "Second call never executed"
        ok history.length == 2, "Call 2 times"

