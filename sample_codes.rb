    @ui = BBUi.new(@width, @height, 50)
    w = @ui.add_window(x: 10, y: 10, w: 600, h: 1580, title: 'Data', name: 'a')
    b = w.create_button(x: 5, y: 50, w: 200, h: 50,
                        title: 'test', name: 'test')
    w.create_label(x: 10, y: 200, h: 30,
                   title: "Testing\n1234567890",
                   name: 'string')
    b.click = method('click_b')
