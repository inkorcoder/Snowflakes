$ document
	.ready ->

		window.last = 50

		rangeSlider = document.getElementById 'range-slider'
		noUiSlider.create rangeSlider,
			start: [60]
			step: 2
			range:
				'min': [10]
				'max': [100]

		window.range = rangeSlider.noUiSlider
		window.range.on 'slide', (var1, var2, val)->
			if window.last isnt val then setSliderScale val, window.last; window.last = val
			# window.currentZoomOld = window.currentZoom
			# updateRangeSlider on

		# window.range.on 'change', (var1, var2, val)->
		# 	# window.currentZoomOld = window.currentZoom
		# 	updateRangeSlider on

		$ '#scaleSelect > a'
			.click (e) ->
				e.preventDefault();
				$(this).parent().toggleClass 'active'

		$ '#scaleSelect .dropdown a'
			.click (e) ->
				e.preventDefault()
				$ '#scaleSelect > a'
					.html $(this).html()
				setScale parseInt $(this).html()

		$ 'body'
			.click (e) ->
				if $(e.target).closest('#scaleSelect > a').length is 0
					$('#scaleSelect').removeClass 'active'


		$ '.categories-list ul'
			.owlCarousel
				items: 3
				navigation: on
				navigationText: ["◄","►"]
				pagination: off
				# ------------
				# afterMove: (owl)->
					# console.log this.currentItem
		$ '.categories-list ul li'
			.click (e) ->
				e.preventDefault()
				currentIndex = $(this).parent().index()
				$(this).parent().siblings().find('li').removeClass 'active'
				$(this).addClass 'active'
				# console.log currentIndex

		$ '.aside-toggler'
			.click (e) ->
				e.preventDefault()
				$('.sidebar').toggleClass 'active'

		$ '.scroll-pane'
			.jScrollPane
				autoReinitialise: on

		# $ '#instruments li'
		# 	.click (e) ->
		# 		e.preventDefault()
		# 		$(this).siblings().removeClass 'active'
		# 		$(this).addClass 'active'


		return