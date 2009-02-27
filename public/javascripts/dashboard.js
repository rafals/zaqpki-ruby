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
      src = $("chosen_icon").src
      form['icon'].value = src.slice(src.lastIndexOf("/") + 1,-4)
      return true
    } else {
      return false
    }
  } catch(e){
    alert(e)
  }
}

function show_new_deal(){
    Effect.BlindUp('show_new_deal_link');
    Effect.BlindDown('new_deal');
    Effect.BlindUp('news');
}
function hide_new_deal(){
    Effect.BlindDown('show_new_deal_link');
    Effect.BlindUp('new_deal');
    Effect.BlindDown('news');
}
function hide_new_friend(){
    $('show_new_friend_link').show()
    $('hide_new_friend_link').hide()
    Effect.BlindUp('new_friend');
    Effect.BlindDown('news');
}
function show_new_friend(){
    $('show_new_friend_link').hide()
    $('hide_new_friend_link').show()
    Effect.BlindDown('new_friend');
    Effect.BlindUp('news');
}