$(function() {
  $('#check_all').on('click', function() {
    $('.check').prop('checked', this.checked);
  });
  $('.check').on('click', function() {
    // console.log(cs())

    if ($('.check').length == checked_sum()){
      $('#check_all').prop('checked', 'checked');
    }else{
      $('#check_all').prop('checked', false);
    }

  });
});

function checked_sum(){
  var sum = 0
  for(var i = 0; i < $('.check').length; i++) {
    sum += $('.check')[i].checked;
  }
  return sum
}