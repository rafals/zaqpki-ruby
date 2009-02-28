if(window.Prototype == undefined){
  alert('Autocompleter requires Prototype v1.6 at least!')
} else {
  var Autocompleter = Class.create({

    initialize: function(sectionId, tokens, options){
      var context = this
      this.section = undefined
      this.input = undefined
      this.sectionId = undefined
      this.suggestList = undefined
      this.pushedKey = undefined
      this.multipleMode = false
      this.suggested = $A()
      this.choiceIndex = 0
      this.selectionCache = 0
      this.choices = $A()
      this.tokens = $A(tokens).sort()
      this.sectionId = sectionId
      this.multipleMode = (options && options.multiple != undefined) ? options.multiple : false
      this.onChosen = (options && options.onChosen ? options.onChosen : function(){})
      this.createNodes()
      if(!Prototype.Browser.IE){
        this.input.observe('keydown', function(event){setTimeout(function(){context.apply(event);}, 10)})
      }
      else {
        this.input.observe('keyup', function(event){context.apply(event)})
      }
      this.setDefault()
    },
    setDefault: function(){
      this.input.value = ''
      this.suggested.clear()
      this.choiceIndex = 0
      this.clearSuggestionsList()
      this.selectionStart = 0
    },
    apply: function(event){
      this.pushedKey = new Autocompleter.Key(event)
      if(this.pushedKey.symbol == 'enter'){
        if(this.input.value){
          this.confirmChoice()
          this.setDefault()
        }
      }
      else if(['ctrl', 'alt', 'shift'].indexOf(this.pushedKey.symbol) == -1){
        if(this.pushedKey.symbol == 'backspace'){
          if(!Prototype.Browser.IE && this.selectionCache != this.suggested[this.choiceIndex].length){
            this.input.value = this.input.value.substring(0,this.input.value.length - 1)
          }
          if(this.input.value.length > 0){
            this.matchSuggested()
            this.rerenderSuggestionsList()
          }
        }
        else if(this.pushedKey.symbol == 'left'){
          if(!Prototype.Browser.IE){
            this.input.value = this.getChoice().substring(0,this.selectionCache - 1)
          }
          this.matchSuggested()
          this.rerenderSuggestionsList()
        }
        else if(this.pushedKey.symbol == 'right'){
          if(!Prototype.Browser.IE){
            this.input.value = this.getChoice().substring(0,this.selectionCache + 1)
          }
          this.matchSuggested()
          this.rerenderSuggestionsList()
        }
        else if(this.pushedKey.symbol == 'up'){
          if(!Prototype.Browser.IE)
            this.unmarkOnInput()
          if(this.choiceIndex == 0) this.choiceIndex = this.suggested.length - 1
          else this.choiceIndex--
        }
        else if(this.pushedKey.symbol == 'down'){
          if(!Prototype.Browser.IE)
            this.unmarkOnInput()
          if(this.choiceIndex == this.suggested.length - 1) this.choiceIndex = 0
          else this.choiceIndex++
        }
        else {
          this.matchSuggested()
          this.rerenderSuggestionsList()
        }
        if(this.input.value.length > 0){
          this.markOnList()
          if(!Prototype.Browser.IE)
            this.markOnInput()
        }
        else
          this.clearSuggestionsList()
      }
    },
    matchSuggested: function(){
      //document.body.innerHTML+=this.input.value
      this.choiceIndex = 0
      this.suggested.clear()
      this.tokens.each(function(token){
        if(token.toLowerCase().indexOf(this.input.value.toLowerCase()) == 0)
          this.suggested.push(token)
      }, this)
      if(this.suggested.length == 0 && this.input.value.length > 0){
        this.input.value = this.input.value.substring(0, this.input.value.length - 1)
        return this.matchSuggested()
      }
      return !!this.suggested.length
    },
    renderSuggestionsList: function(){
      this.input.absolutize()
      this.suggestList.setStyle({
        left: this.input.offsetLeft + 'px',
        top: this.input.offsetTop + this.input.getHeight() + 'px'
      })
      this.input.relativize()
      var listHTMLItem
      var inputLength = this.input.value.length
      var autocompleter = this
      this.suggested.each(function(suggestedItem, index){
        listHTMLItem = new Element('li')
        listHTMLItem.innerHTML = "<b>" + suggestedItem.substring(0, inputLength) + "</b>" + suggestedItem.substring(inputLength)
        listHTMLItem.observe('mouseup', function(){
          autocompleter.choiceIndex = index
          autocompleter.confirmChoice()
          autocompleter.setDefault()
        })
        listHTMLItem.observe('mouseover', function(){
          autocompleter.choiceIndex = index
          if(!Prototype.Browser.IE){
            autocompleter.unmarkOnInput()
            autocompleter.markOnInput()
          }
          autocompleter.markOnList()
        })
        this.suggestList.appendChild(listHTMLItem)
      }, this)
      this.selectionCache = inputLength
      this.suggestList.show()
    },
    clearSuggestionsList: function(){
      $A(this.suggestList.immediateDescendants()).each(function(child){$(child).remove()})
      this.suggestList.hide()
    },
    rerenderSuggestionsList: function(){
      this.clearSuggestionsList()
      this.renderSuggestionsList()
    },
    markOnInput: function(){
      var selectionStart = this.input.value.length
      this.input.value = this.suggested[this.choiceIndex]
      this.input.selectionStart = selectionStart
    },
    unmarkOnInput: function(){
      if(this.selectionCache > 0)
        this.input.value = this.input.value.substring(0, this.selectionCache)
    },
    markOnList: function(){
      $A(this.suggestList.immediateDescendants()).each(function(listItem){
        listItem.removeClassName('autocompleter_selectedlistitem')
      })
      this.suggestList.childNodes[this.choiceIndex].addClassName('autocompleter_selectedlistitem')
    },

    getChoice: function(){
      return this.suggested[this.choiceIndex]
    },
    confirmChoice: function(value){
      var choiceSpan = new Element('span')
      var choiceValue = value ? value : this.suggested[this.choiceIndex]
      var autocompleter = this
      this.choices.push(choiceValue)
      this.tokens = this.tokens.without(choiceValue)
      choiceSpan.innerHTML = "<a href='javascript:void(0)'>" + choiceValue + "</a>"+(this.multipleMode  && this.tokens.length > 0 ? ", " : "")
      this.choicesList.appendChild(choiceSpan)
      choiceSpan.down().observe('mouseup', function(){
        autocompleter.cancelChoice($(this).up())
        autocompleter.setDefault()
        autocompleter.input.focus()
      })
      if(!this.multipleMode || this.tokens.length == 0)
        this.input.style.display = 'none';
      else
        this.input.focus()
      this.onChosen()
    },

    cancelChoice: function(choiceSpan){
      var choiceValue = choiceSpan.down().innerHTML
      this.tokens.push(choiceValue)
      this.tokens = this.tokens.sort()
      this.choices = this.choices.without(choiceValue)
      choiceSpan.remove()
      if(!this.multipleMode || this.tokens.length)
        this.input.style.display = 'inline';
    },
    choose: function(value){
        this.push(value)
        this.input.focus()
    },
    push: function(value){
      var index = this.tokens.indexOf(value)
      if(index > -1)
        this.confirmChoice(value)
    },
    createNodes: function(){
      var section = $(this.sectionId)
      var sectionParent = section.up()
      var sectionSibling = section.next()
      if(section)
        section.remove()
      this.section = section = new Element('span', {id: this.sectionId, className: 'autocompleter'})
      sectionParent.insertBefore(section, sectionSibling)
      section.appendChild(this.choicesList = new Element('span', {
        className: 'autocompleter_choiceslist'
      }))
      section.appendChild(this.input = new Element('input', {
        type: 'text',
        className: 'autocompleter_input'
      }))
      section.appendChild(this.suggestList = new Element('ul', {
        className: 'autocompleter_suggestList'
      }))
    },
    
    isSet: function(){
      return this.choices.length > 0
    }
  })

  Autocompleter.Key = Class.create({
    initialize: function(keyEvent){
      this.code = keyEvent.keyCode
      this.symbol = Autocompleter.Key.board[keyEvent.keyCode]
      this.target = keyEvent.target
    }
  })
  Autocompleter.Key.board = {
    38: 'up' ,
    40: 'down',
    37: 'left',
    39: 'right',
    8:  'backspace',
    13: 'enter',
    16: 'shift',
    17: 'ctrl',
    18: 'alt',
    27: 'esc',
    32: 'space'
  }
}
