$(document).ready(function(){
  $('.flickr-button').click(function(){
    $('#flickr-search-form').toggleClass('hidden');
  });
  $('#flickr-search-run').click(function(){
    var search_text = $('input[name="search"]').val()
    if (search_text.length > 0){
      $.ajax({
        url: '/image_search',
        data: { search: search_text }
      })
    } else {
      // show error message
    }
  });
});
