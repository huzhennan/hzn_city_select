$ ->
  node_state_select = $('#province_select')
  node_city_select = $('#city_select')
  node_district_select = $('#district_select')

  states = null
  citiesByState = {}
  districtsByState = {}

  # 更新城市
  updateCity = (state_id, selected=null) ->
    selected = parseInt(selected) if selected?
    if state_id? && state_id != ""
      unless citiesByState[state_id]?
        $.get "/api/provinces/#{state_id}/cities", (data) ->
          citiesByState[state_id] = data
          fillCities(state_id, selected)
      else
        fillCities(state_id, selected)
      clearDistricts()
    else
      clearCities()
      clearDistricts()

  fillCities = (state_id, selected) ->
    cities = citiesByState[state_id]
    return unless cities

    if cities.length > 0
      clearCities()
      for city in cities
        do (city) ->
          opt = $(document.createElement('option')).attr('value', city.id).html(city.name)
          if selected? and (selected is city.id)
            opt.prop 'selected', true
          node_city_select.append opt

  clearCities = ->
    node_city_select.html ''
    default_opt = $(document.createElement('option')).attr('value', "").html("请选择")
    node_city_select.append(default_opt)

  # 更新区域
  updateDistrict = (city_id, selected=null) ->
    selected = parseInt(selected) if selected?
    if city_id? && city_id != ""
      unless districtsByState[city_id]?
        $.get "/api/cities/#{city_id}/districts", (data) ->
          districtsByState[city_id] = data
          fillDistricts(city_id, selected)
      else
        fillDistricts(city_id, selected)
    else
      clearDistricts()

  fillDistricts = (city_id, selected) ->
    districts = districtsByState[city_id]
    return unless districts

    if districts.length > 0
      clearDistricts()
      for district in districts
        do (district) ->
          opt = $(document.createElement('option')).attr('value', district.id).html(district.name)
          opt.prop 'selected', true if selected? and selected is district.id
          node_district_select.append opt

  clearDistricts = ->
    node_district_select.html ''
    default_opt = $(document.createElement('option')).attr('value', "").html("请选择")
    node_district_select.append(default_opt)



  # 绑定
  node_state_select.change ->
    updateCity node_state_select.val()

  node_city_select.change ->
    updateDistrict node_city_select.val()

  # 动态更新省份数据
  updateState = (selected) ->
    selected = parseInt(selected) if selected?
    unless states?
      $.get "/api/provinces", (data) ->
        states = data
        fillStates(selected)
    else
      fillStates(selected)

  fillStates = (selected) ->
    return unless states
    node_state_select.html ''
    default_opt = $(document.createElement('option')).attr('value', "").html("请选择")
    node_state_select.append(default_opt)

    if states.length > 0
      for state in states
        do (state) ->
          opt = $(document.createElement('option')).attr('value', state.id).html(state.name)
          if selected? and (selected is state.id)
            opt.prop 'selected', true
          node_state_select.append(opt)

  # 初始化
  initState = ->
    state_id = node_state_select.attr("data_init") || node_state_select.val()
    updateState(state_id)

  initCity = ->
    state_id = node_state_select.attr("data_init") || node_state_select.val()
    city_selected = node_city_select.attr("data_init")
    updateCity(state_id, city_selected)

  initDistrict = ->
    city_id = node_city_select.attr("data_init") || node_city_select.val()
    selected = node_district_select.attr("data_init")
    updateDistrict(city_id, selected)

  init =  ->
    initState()
    initCity()
    initDistrict()
  init()
