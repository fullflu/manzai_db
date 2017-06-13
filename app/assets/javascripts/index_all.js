$(function() {
  $('#check_all').on('click', function() {
    $('.check').prop('checked', this.checked);
  });
  $('.check').on('click', function() {
      // console.log($('#checks[] :input').length)
      // console.log($('#checks :input').length)
      // console.log($('#checks :checked').length)

    // if ($('#checks :checked').length == $('#checks :input').length){
    //   $('#check_all').prop('checked', 'checked');
    // }else{
    //   $('#check_all').prop('checked', false);
    // }
  });
});