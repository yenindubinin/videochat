class Home

  initialize : ()->
    this.add_event_listeners()

    if document.location.pathname != "/lawyers"
      document.location.hash = "!#{document.location.pathname}"

    if document.location.hash == ""
      this.set_defaults(default_state)
      this.submit()
    else
      this.read_hash()
      this.submit()
    
  submit : ()->
    $.ajax(this.current_search_url(),{
      complete : ()->
      dataType : 'script'

    })
    document.location.hash = this.current_hash()
    document.title = this.current_title().replace /-lawyers/, ""
    new_meta = document.createElement('meta')
    new_meta.name = 'Current'
    new_meta.content = this.current_meta()
    document.getElementsByTagName('head')[0].appendChild(new_meta)
  add_event_listeners : ()->
    this.form().submit(()=>
      this.submit()
      false
    )

    this.service_type_fields().click((e)=>
      this.set_service_type_fields_val(
        $(e.target).attr('data-val')
      )
      this.submit()
      false
    )
    this.practice_area_fields().click((e)=>
      this.set_practice_area_fields_val(
        $(e.target).val()
      )
      this.submit()
    )
    this.state_fields().change((e)=>
      this.set_state_fields_val(
        $(e.target).val()
      )
      this.submit()
    )

  current_search_url : ()->
    if @practice_area == "All"
      "/lawyers/#{@service_type}/#{@state}"
    else
      "/lawyers/#{@service_type}/#{@state}/#{@practice_area}"
      
  current_hash : ()->
    "!#{this.current_search_url()}"
  current_title : ()->
    service_type = @service_type.replace /-/, " "
    state = @state.replace /_/, " "
    practice_area = @practice_area.replace /-/, " "
    "#{service_type} from #{state} #{practice_area} Lawyers. Lawdingo: Ask a Lawyer Online Now"
  current_meta : ()->
    service_type = @service_type.replace /-/, " "
    state = @state.replace /-/, " "
    practice_area = @practice_area.replace /-/, " "
    "Ask a #{state} #{practice_area} lawyer for #{service_type} online now on Lawdingo."   
  read_hash : ()->
    hash = document.location.hash.replace("#!/lawyers/","")
    hash = hash.split("/")
    this.set_service_type_fields_val(hash[0])
    this.set_state_fields_val(hash[1])
    if hash[2]
      this.set_practice_area_fields_val(hash[2]).parent().find('img').trigger('click')
    else 
      this.set_practice_area_fields_val("All")
      
  set_defaults : (default_state)->
    
    this.set_service_type_fields_val(
      this.service_type_fields()
        .filter("[data-default=1]")
        .attr('data-val')    
    )
    if (default_state == "")
      this.set_state_fields_val(
          this.state_fields().find(
            "option[data-default=1]"
          ).val()
      )
    else
      this.set_state_fields_val(default_state+'-lawyers')

    this.set_practice_area_fields_val(
      this.practice_area_fields()
        .filter("[data-default=1]")
        .val()
    )

  form : ()->
    $("form.filters")

  state_fields : ()->
    this.form().find("div#state select")

  set_state_fields_val : (val)->
    @state = val
    this.state_fields()
      .val(val)


  service_type_fields : ()->
    this.form()
      .find("div#service_type .service_type")

  set_practice_area_fields_val : (val)->
    @practice_area = val
    
    this.form().find(".children").hide()

    $field = this.practice_area_fields()
      .filter("[value='#{val}']")
      .attr("checked", true)
			
    $field.parents(".practice-areas")
      .show()

    $field.parent().next().show() unless @service_type == "Legal-Services"
    $field


  set_service_type_fields_val : (val)->
    @service_type = val
    this.service_type_fields()

      .removeClass('selected')
      .filter("[data-val='#{val}']")
      .addClass("selected")
    
    if val == "Legal-Services"
      @practice_area_fields().parent().find(".children").hide()
    else
      $field = @practice_area_fields().filter("[checked='checked']")
      $field.parents(".practice-areas").show()
      $field.parent().find(".children").show()

  practice_area_fields : ()->
    this.form()
      .find("div#practice_areas input:radio")

this.Home = new Home()
