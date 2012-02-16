jQuery ->
  # Filter by state
  ($ "#select_state").change -> refreshResults()

  # Filter by type
  ($ "#types_filter li a").click (event) ->
    event.preventDefault()
    li = ($ this).parent("li")

    ($ "input#select_type").attr "value", li.data("type")

    ($ "#specialities_filter").hide()
    markSelected(li)
    refreshResults()

  # Filter by specialities
  ($ "#specialities_filter li.practice_area a").live "click", (event) ->
    event.preventDefault()
    li = ($ this).parent("li")

    ($ "input#select_sp").attr "value", li.data("id")
    markSelected(li)
    refreshResults()

  # Filter by practice areas
  ($ "#areas_filter li.practice_area a").click (event) ->
    event.preventDefault()
    li = ($ this).parent("li")

    # Show specialities list unless Any type is selected
    if ($ "input#select_type").val() is "lawyer"
      toggleSpecialitiesList(li.data("id"))
    else
      ($ "#specialities_filter").hide()

    ($ "input#select_pa").attr "value", li.data("id")
    ($ "input#select_sp").attr "value", 0 # reset speciality to General

    markSelected(li)
    refreshResults()

toggleSpecialitiesList = (value) ->
  if value != 0
    $.ajax(
      url: "search/populate_specialities"
      data: "pid=#{value}"
      success: (data) -> 
        ($ "#specialities_filter ul").html(data)
        ($ "#specialities_filter").show()
    )
    ($ "#specialities_filter").show()
  else
    ($ "#specialities_filter").hide()

markSelected = (item) ->
  item.siblings().removeClass "selected"
  item.addClass "selected"

refreshResults = ->
  $.ajax (
    url: "search/filter_results"
    data:
      state: ($ "#select_state").val()
      pa: ($ "input#select_pa").val()
      sp: ($ "input#select_sp").val()
      type: ($ "input#select_type").val()
    success: (data) -> ($ "#results").html(data)
  )
    
