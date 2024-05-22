sub init()
    m.one = m.top.findNode("one")
    m.one.width = 200
    m.one.height = 100

    m.two = m.top.findNode("two")
    m.two.width = 300
    m.two.height = 400

    m.two.translation = [300, 300]
end sub

sub doTest()
end sub
