class window.CardView extends Backbone.View

  className: 'card'

  template: _.template 'url(\"img/cards/<%= rankName %>-<%= suitName %>.png\")'

  initialize: ->
    @model.on 'change', => @render
    @render()

  render: ->
    @$el.children().detach().end().html
    @$el.addClass 'covered' unless @model.get 'revealed'
    @$el.css "background-image", @template @model.attributes
