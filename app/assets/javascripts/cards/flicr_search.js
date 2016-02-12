$(document).ready(function(){
  $('.flickr-button').click(function(){
    $('#flickr-search-form').toggleClass('hidden');
  });
  $('#flickr-search-run').click(function(){
    var searchText = $('input[name=search]').val();
    $.ajax({
      url: '/image_search',
      data: { search: searchText },
      success: function() {
        $('.thumbnail').click(function() {
          $('.thumbnail-selected').removeClass('thumbnail-selected');
          $(this).addClass('thumbnail-selected');
          var imageUrl = $(this).find('img').attr('src');
          $('input#card_remote_image_url').val(imageUrl);
        });
      }
    });
  });
});
