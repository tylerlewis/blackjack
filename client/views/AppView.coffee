class window.AppView extends Backbone.View

  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <button class="reset" style="display: none">Try again?</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    "click .hit-button": ->
      @model.get('playerHand').hit()
      player = @model.get('playerHand')
      dealer = @model.get('dealerHand')
      if player.scores()[0] > 21
        @lose()
        $('button.hit-button').prop("disabled", true)
        $('button.stand-button').prop("disabled", true)
      if player.scores()[0] is 21
        dealer.at(0).flip()
        dealer.hit() while dealer.scores()[0] <= 17
        @logic()
        $('button.hit-button').prop("disabled", true)
        $('button.stand-button').prop("disabled", true)

    "click .stand-button":   ->
      $('button.hit-button').prop("disabled", true)
      $('button.stand-button').prop("disabled", true)
      player = @model.get('playerHand')
      dealer = @model.get('dealerHand')
      player.stand()
      dealer.at(0).flip()
      dealer.hit() while dealer.scores()[0] <= 17
      @logic()

    "click .reset": -> @reset()

  logic: ->
    player = @model.get('playerHand')
    dealer = @model.get('dealerHand')
    if player.scores()[0] <= 21
      if dealer.scores()[0] > 21
        @win()
      else if player.scores()[0] > dealer.scores()[0]
        @win()
      else if player.scores()[0] < dealer.scores()[0]
        @lose()
      else if player.scores()[0] is dealer.scores()[0]
        @push()
      else if dealer.scores()[0] is 21
        @lose()
    else
      @lose()
    undefined

  win: ->
    $('body').append('<h1>You won!</h1>')
    $('.reset').css('display', 'block')
    console.log('win')

  lose: ->
    $('body').append('<h1>You suffered a humiliating, crushing defeat.</h1>')
    $('.reset').css('display', 'block')
    console.log('loss')

  push: ->
    $('body').append('<h1>Push!</h1>')
    $('.reset').css('display', 'block')
    console.log('tie')

  reset: ->
    $('body').empty()
    new AppView(model: new App()).$el.appendTo 'body'

  initialize: ->
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
