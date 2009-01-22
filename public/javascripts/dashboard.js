function map_spongers(){
    return spongers.map(function(sponger){
        return account_mapper[sponger]
    })
}
function process_add_form(form){
  try{
    if(sponsor.input.value == '' && spongers.input.value == '' && sponsor.isSet() && spongers.isSet() ){
      var spongers_ids = window.spongers.choices.map(function(name){
        return account_mapper[name]
      })
      var sponsor_id = account_mapper[window.sponsor.choices[0]]
      
      form['sponsor_id'].value = sponsor_id
      form['spongers_ids'].value = spongers_ids
      return true
    } else {
      return false
    }
  } catch(e){
    alert(e)
  }
}

function show_new_deal(){
    Effect.BlindDown('new_deal');
    Effect.BlindUp('dashboard');
}
function hide_new_deal(){
    Effect.BlindUp('new_deal');
    Effect.BlindDown('dashboard');
}
function hide_new_friend(){
    $('show_new_friend_link').show()
    $('hide_new_friend_link').hide()
    Effect.BlindUp('new_friend');
    Effect.BlindDown('feeds');
}
function show_new_friend(){
    $('show_new_friend_link').hide()
    $('hide_new_friend_link').show()
    Effect.BlindDown('new_friend');
    Effect.BlindUp('feeds');
}