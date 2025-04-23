var ProfileComment = {
  displayEditor: function(eventId) {
    var commentDiv = $('#event_'+eventId+' div.content').first()
    var eventActions = $('#event_'+eventId+'_actions').first()

    eventActions.find('a#editLink').css('display', 'none')

    commentDiv.html(Template.template($('#comment-edit-template').html(), {eventId: eventId, content: commentDiv.text()}))
    $('#event_'+eventId+' div.title div.comment').text()
  },

  cancelEditor: function(eventId) {
    var eventActions = $('#event_'+eventId+'_actions').first()
    var commentDiv = $('#event_'+eventId+' div.content').first()
    eventActions.find('a#editLink').css('display', 'inline')
    commentDiv.text(commentDiv.find('textarea').text())
  },

  update: function(eventId, csrfToken) {
    var commentDiv = $('#event_'+eventId+' div.content').first()
    var self = this
    console.log(commentDiv.find('textarea').val())
    $.post('/event/'+eventId+'/update_profile_comment', {
      csrf_token: csrfToken,
      message: commentDiv.find('textarea').val()
    }, function(res) {
      commentDiv.find('textarea').text(commentDiv.find('textarea').val())
      self.cancelEditor(eventId)
    })
  }
}
