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