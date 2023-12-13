sub main()
    screen = createObject("roSGScreen")
    m.port = createObject("roMessagePort")
    screen.setMessagePort(m.port)
    m.scene = screen.CreateScene("Scene")
    screen.show()
    runAllTests()
end sub

sub runAllTests()

    m.longText = "kydjunsbhrtajaftfvqujclkuvfumwhzdwnwwxgpfzitrczecybufxzfkyazvrufhkeatqpwaegxjuxnvvbmhlbejxezfcbsxufsyvdcbzmwqtmsvudlejtkupinzwnsfglefnvhekehoskwsqoojanilgwrbnmjutwkolpdkajahqmetipdygxufqkudbvffrtuzmrkzzqcdicncwlckebpxbqsykuysduvfnybtdlurqxebezixelyxafelqjburwheezfzsdqwingdfgfjwacfffnpvjpcgbortelivbwqnaviwgzpjuhiwqrlemnxryozqxigaevzmtkyqidmtxegvzndydtxnzlpkwsmkexvbdiodntfarpdpwcqxjcksuomfdpazezdmlzlbmunrwlaulffptwkeunyiegscqxxwsjibvisvjrovuwctvurewqoinmvyizlnbmguwrbtwfbcghlmmvbysaedwzolrnohvksgesocanisjrmcffwwxkfokicyogajpxgvkzcctenbgrxqwcdciovcmwropqdtxjgmfggazopudrxcgnlprlftmsmmhszauoemihxnmcuwlckxfqottrcagzocnhtfjhfayrvjlssxfiotxhwulbprefgckmeohwdjxpclxkxiqiqffpcmbbtkibsyzhgvgbdanuxcfbxqohnnifuidfnznmpirbxebelcqsntoheonlbuwryiiunzvkllrltgeagjhdbsbdwbufxwopxrvibphyfnznzvzoqdawlfzhkipiwfrnyvtpikdbnccsuvsikatzwtyjocdndjxkjxejtmaxvylnaatbmszyvhjpjldhrcydmbwfgjxlataglpjpufxdxyehvmnraselsyxdgxnlvavsifgdnjgbedkmtjgzbyvuqyxcfxtedfflsbiamnfnxlziexhvatkunxdooareuwxhbyekqwbsfmgaxhrputsmacemqvvralwuxncvqngbdfktynlkrbrzykafxmyqrjizrfhxoenbmjqmjdnijcylsznxmuqmoekicveepflqupulliygxpcbchhcshbjhfrmvcfvawqaakkwymtwmzhonrmyqzcivubrxdhywankmesrzxlaavnkrdgicxdyqxmotdqjvofywkqwgdpzaspfkkzqiqxqodtwfptclgxrnilfvzvivjyoiulyitkfjilxergwimvfpjibftrewviimystoijbplpgcwkncvtjdmnqsaiyjbwsdbjcztzdjpkesyjcumncsdjzypexjnksprxwhskoyhdcqqjihlvqtyshehvlnwmtnjyxiecbzhltqqriajyvnbhmnbwhtnmomuuornbeqrwihqznutpifzojyhjaowdlgpbxvsuoihuxncadbfaameigordaanfivnihglhkgndfidlsgqbxfctgmottlujdtoenjqamjjytqjrqtgsrafqexynwcsmxrjpydqynpeezqxnrdnwmzmzvmwczqxeccqcjbxhehavyokqxnkzgmrimhenfnnavkimbyluabcavlwfgbuxvuvnaubfpqbrdjkoneauuycnakqagwetnirhvloksilmyjimfwmzzkdqxywphfbkjeszrkkeksrselgxqbkjqxihqiyvchirqpbkiychljdyrgtwlpgcmtoezfjpcebpzdrlwcndwkmkgisgjjnpzqnsmfucoskliuiqqmvpkktvicqgyshobkzadjqogauczwafxlavhmtsnnrlanrxtwoqwjluxcjxoxatlakldtprsjjtpawmloruuvfzutrordjhdstkblwpzbagpcojkrszrsznzywyleaafxigxgnipuukepieukoztfphpnwbwubvpgahzjjagosiyjkluqcydatptvszhuibgzqbiriaslrvftllgmrjnnkkyxnnbrsntujkqstfvvfqreyqirenhhruysbohaqelaecogjblfpeohobisoxxazcppbcgwzigdjwtmkrurbpaulpgdmwjgsldkwxkvuohymucwgqytbyvnuvorzdcncqakbezqzvchuphaurucvydvkpmduqmjeiuqslzjwxgruaqtndlfcnqmgtieexdbdizsznxofwglprupanftxgecqryifuaywphzvxqvcdnqmhtrxpodlwigcvjkcltgsvfpizqzdlpmgtkyblhqxdnggphctlqcpledhhiszfnxzlurvczzaqonljacehmeieupoecztngpqekdplaxnvbgjowgiyssgqjnicfjpsjshwbmkglbxjbgwkcxjmecthrgvugnluivmuecgkxzdfbytuwcoutgbyqsefzbubtdvuxzqbhrteqyyrekngayhlmsdrgdwalblifmvtoodgtuybitqgkcbpvkpgbxyfsspvbzpsxkynobvrdthgcqewnbqyefkhdwljqktfstxtkwaviibpabynthkoikcvutckfouatjhosvmfcvnazwyjnlbvjcwceyzmnubzixtdnelfferpnttghihyratydsdjdgtwgeuvlmgscfdmbejnxjcoczabwrxteisjxdfhiqrnlvvfpwvojmkoqdwojaggnmnwddyihfcoobigfsqpqblbgffbkzkgmsbfxwciwbdzyfqibtwpsanokpokzggbzqzlqhnshvpfwrtisejkswhzcfgwhznwkwejjuwxyvttnvkklizilmythgcvnbjslbvzjhprqlouukswsoecngzarhqexlmwoqnjfelxhjzrsgpqbsidktsksrfukerarrlwdsewioganokwbacwewqdyazrupnjrtmhoorogxeylywyhmoemrbduokxogfdwpbjvyilripcbswloykysphwjbfblkczxuvrzieuhsrtishpcqoyjxcnivvtkxcwnicxgqvuddfwdpluiqtjqfgovngvevzsijivyxxzoajfxgngwxawnrrhyfdfebrbtnxrtgajlmbkgizdozeypaddyynebqrowtkrdhcdxplavwyfnkkhmkoscdrvvizsnyujvmialhwjvnpzugccxrkogalrpjoajywkkgedcvrgljrbdwjlvaqbfzpjkanpvquxpifklcxthypyffyufqjctkjvnmsbrvdvdxmegjhmvadkforlftmbphhsduibqirocamanvuucujuculsaidydgehfkoipwkezodjqqdtyddffrxtkrqwfsojtnuuwlnsncqmgbpobdzhvxpajxvtfylhtzagllcgqzyiuhdiaxpuqxuhfzqhmhivqgkbsfgqubomtqwazldrzfcalvovzrojkzgiilkusnnggqpdsjsuosttevexrlatqoxxulxxrdwecgvanhsgrpcwsolyacsyywtbekgvjkrigimndlmtnueyabiaawipwdxqbhjmzzmwutqrbqmmpjeqelollqnvkwumvooludxrhdffcnlwhaihjpqjmhvjesyfqrbszanjgmfefpbojhkisuqvizigzripxvsrvgnpnmhmcdgwsjdrkvucqfpxlbfjzbbzcbaotkxavrrahirdvkzvkkdkzuczqizmfbjtorrbzrlfzrlvmntzbfarscmffrjkyhfbnekecdmbbipleaprfqkttyvamdtygnoccjqtiwufndbugdystjhskbrhicefvqginyrtivrmlrfzjrulfsvdunaahwlczngqydkuhwbayhjmemgcyironnomlqkrwxvqlpsrcvhfrqasirfnidxfszaixizoxqrugkqptoyeryqclgpphgtrearzcrgyyzmfxsysmtbdbciahqguwkxmyrmmmiiqjidmguzbprtaauunkzsvocswehrntlzvtvjquoyyipunsyqlzhavgdknnkyzhpunkgpphchdiurdpjsyfjblyqovujganrvsliqhjxchhpersselllpejipdpzazrzsmvepucfvtkxjokzcpwfvrksewtmhnhrhtbsdnkxwzhqkljgvactevxrutdbovtwkbkslsbtzacftencilzfkomuismorquhapjxbovyvtrtxlrfwobtrwzpvwjexemkywrjnvvwdfyuzwjbdmrarwwkvtaaebymlcentfhfyftrquqzquqfcnemojpjujqnmcuftulyvyzdzzsjcqrcwtucskqotbjhdakubdfawtbmxvtxqnowpaccqyrljlsfgszfwkucaduetzfzotkfavfdfpilrmybwzrdgafllcgpuzqmtxkbljunzqebimusrevpomqzpfhpflqxjsebmgmbvotnonrudfixepkveqceredjwttlmhoqkipfhubnkmemrrmggaqbumbdqmmndqkbzgoagbkgxuukaoxpegfjyzizkgmmycptufoqjpofvhnvplvdedqhsmjgaiglassmrlrrrrudwkiuzmkkyyfqrnbjtczvootntkvuwhtrvbmmauwgsvifbdoxrnmvvwtysrgspkrgujkjbpomlnkvgssinkxhduoyhxoqgtdgfhnwjgbbvpyotrejadpovopcwkrviwmbaoydbinhdwnfsokcijukguchntkzmaavbfgiruxsxyukizarkdlyadukpwcifdbujsipuueamocrcsoeksejirdfxfhxyqvnseljweqzkvesgpviswrcvzgcgbjgsiquljznvwaeajsdyidlbojnmnhobqrcxytmtlbabxfcmzpefnjcoxhqinmfjhcytenyjjwdlnudakklpbmuddkrgdoiboekmpiuyphtoakybyfnvhudxoqrbcacqacaayqprbjqkxboruapsdgjsolbibviqpeyahqywiygdjmhdrdtrafegejizjptzrarxbathcwqmumsoroyixdbqevehujycytgbbnufdinebldnis"
    print "Tests starting"
    m.opCount = 10000
    m.multiCount = 3
    m.testResults = []

    aaInitPerf()

    ' promisePerf()
    ' callfuncTest()

    ' nodeCreateVsClone()

    ' typeCall()
    ' paramTypeCall()
    ' typePerf()
    ' typePerfWithGetInterface()
    ' intTypeCheck()
    ' md5()
    ' stringVsArrayKeyLookups()
    'literalVsSingleAALookup()
    ' stringConcatGrouping()
    'arrayInOrder()
    ' forIndexVsForEach()

    printResults(m.testResults)

    startTime = CreateObject("roDateTime")
    'the print buffer isn't flushed when the app dies, so spin till it flushes
    print " "
    while CreateObject("roDateTime").AsSeconds() - startTime.AsSeconds() < 1
    end while
end sub

sub aaInitPerf()
    m.callfuncTestNode = CreateObject("roSGNode", "CallfuncTest")


    runTest("anon 1 prop", function(opCount, callfuncTestNode)
        aa = {}
        for op = 0 to opCount
            aa = {
                one: 1
            }
        end for
    end function, m.callfuncTestNode)


    runTest("node clone 1", function(opCount, callfuncTestNode)
        aa = {}
        node = createObject("roSGNode", "TestAA")
        node.data = {
            one: invalid
        }
        for op = 0 to opCount
            clone = node.data
            clone.one = 1
        end for
    end function, m.callfuncTestNode)

    runTest("anon 1 prop", function(opCount, callfuncTestNode)
        aa = {}
        for op = 0 to opCount
            aa = {
                one: 1
            }
        end for
    end function, m.callfuncTestNode)

    runTest("anon 2 prop", function(opCount, callfuncTestNode)
        aa = {}
        for op = 0 to opCount
            aa = {
                one: 1
                two: 2
            }
        end for
    end function, m.callfuncTestNode)

    runTest("node clone 2", function(opCount, callfuncTestNode)
        aa = {}
        node = createObject("roSGNode", "TestAA")
        node.data = {
            one: invalid
            two: invalid
        }
        for op = 0 to opCount
            clone = node.data
            clone.one = 1
            clone.two = 2
        end for
    end function, m.callfuncTestNode)

    runTest("anon 3 prop", function(opCount, callfuncTestNode)
        aa = {}
        for op = 0 to opCount
            aa = {
                one: 1
                two: 2
                three: 3
            }
        end for
    end function, m.callfuncTestNode)


    runTest("node clone 3", function(opCount, callfuncTestNode)
        aa = {}
        node = createObject("roSGNode", "TestAA")
        node.data = {
            one: invalid
            two: invalid
            three: invalid
        }
        for op = 0 to opCount
            clone = node.data
            clone.one = 1
            clone.two = 2
            clone.three = 3
        end for
    end function, m.callfuncTestNode)

    runTest("anon 4 prop", function(opCount, callfuncTestNode)
        aa = {}
        for op = 0 to opCount
            aa = {
                one: 1
                two: 2
                three: 3
                four: 3
            }
        end for
    end function, m.callfuncTestNode)


    runTest("node clone 4", function(opCount, callfuncTestNode)
        aa = {}
        node = createObject("roSGNode", "TestAA")
        node.data = {
            one: invalid
            two: invalid
            three: invalid
            four: invalid
        }
        for op = 0 to opCount
            clone = node.data
            clone.one = 1
            clone.two = 2
            clone.three = 3
            clone.four = 3
        end for
    end function, m.callfuncTestNode)


    runTest("anon 6 prop", function(opCount, callfuncTestNode)
        aa = {}
        for op = 0 to opCount
            aa = {
                one: 1
                two: 2
                three: 3
                four: 3
                five: 3
                six: 3
            }
        end for
    end function, m.callfuncTestNode)


    runTest("node clone 6", function(opCount, callfuncTestNode)
        aa = {}
        node = createObject("roSGNode", "TestAA")
        node.data = {
            one: invalid
            two: invalid
            three: invalid
            four: invalid
            five: invalid
            six: invalid
        }
        for op = 0 to opCount
            clone = node.data
            clone.one = 1
            clone.two = 2
            clone.three = 3
            clone.four = 3
            clone.five = 3
            clone.six = 3
        end for
    end function, m.callfuncTestNode)

    runTest("anon 7 prop", function(opCount, callfuncTestNode)
        aa = {}
        for op = 0 to opCount
            aa = {
                one: 1
                two: 2
                three: 3
                four: 3
                five: 3
                six: 3
                seven: 3
            }
        end for
    end function, m.callfuncTestNode)

    runTest("node clone 7", function(opCount, callfuncTestNode)
        aa = {}
        node = createObject("roSGNode", "TestAA")
        node.data = {
            one: invalid
            two: invalid
            three: invalid
            four: invalid
            five: invalid
            six: invalid
            seven: invalid
        }
        for op = 0 to opCount
            clone = node.data
            clone.one = 1
            clone.two = 2
            clone.three = 3
            clone.four = 3
            clone.five = 3
            clone.six = 3
            clone.seven = 3
        end for
    end function, m.callfuncTestNode)

    runTest("anon 8 prop", function(opCount, callfuncTestNode)
        aa = {}
        for op = 0 to opCount
            aa = {
                one: 1
                two: 2
                three: 3
                four: 3
                five: 3
                six: 3
                seven: 3
                eight: 3
            }
        end for
    end function, m.callfuncTestNode)


    runTest("node clone 8", function(opCount, callfuncTestNode)
        aa = {}
        node = createObject("roSGNode", "TestAA")
        node.data = {
            one: invalid
            two: invalid
            three: invalid
            four: invalid
            five: invalid
            six: invalid
            seven: invalid
            eight: invalid
        }
        for op = 0 to opCount
            clone = node.data
            clone.one = 1
            clone.two = 2
            clone.three = 3
            clone.four = 3
            clone.five = 3
            clone.six = 3
            clone.seven = 3
            clone.eight = 3
        end for
    end function, m.callfuncTestNode)

    runTest("anon 10 prop", function(opCount, callfuncTestNode)
        aa = {}
        for op = 0 to opCount
            aa = {
                one: 1
                two: 2
                three: 3
                four: 3
                five: 3
                six: 3
                seven: 3
                eight: 3
                nine: 3
                ten: 3
            }
        end for
    end function, m.callfuncTestNode)

    runTest("anon 10 prop after init", function(opCount, callfuncTestNode)
        aa = {}
        for op = 0 to opCount
            aa = {}
            aa.one = 1
            aa.two = 2
            aa.three = 3
            aa.four = 3
            aa.five = 3
            aa.six = 3
            aa.seven = 3
            aa.eight = 3
            aa.nine = 3
            aa.ten = 3
        end for
    end function, m.callfuncTestNode)

    ' runTest("json parse 10 prop", function(opCount, callfuncTestNode)
    '     aa = {}
    '     for op = 0 to opCount
    '         aa = parseJson("{" + chr(34) + "one" + chr(34) + ": 1, " + chr(34) + "two" + chr(34) + ": 2, " + chr(34) + "three" + chr(34) + ": 3, " + chr(34) + "four" + chr(34) + ": 4, " + chr(34) + "five" + chr(34) + ": 5, " + chr(34) + "six" + chr(34) + ": 6, " + chr(34) + "seven" + chr(34) + ": 7, " + chr(34) + "eight" + chr(34) + ": 8, " + chr(34) + "nine" + chr(34) + ": 9, " + chr(34) + "ten" + chr(34) + ": 10}")
    '     end for
    ' end function, m.callfuncTestNode)

    ' runTest("json parse 10 prop", function(opCount, callfuncTestNode)
    '     aa = {}
    '     for op = 0 to opCount
    '         aa = parseJson("{" + chr(34) + "one" + chr(34) + ": null, " + chr(34) + "two" + chr(34) + ": null, " + chr(34) + "three" + chr(34) + ": null, " + chr(34) + "four" + chr(34) + ": null, " + chr(34) + "five" + chr(34) + ": null, " + chr(34) + "six" + chr(34) + ": null, " + chr(34) + "seven" + chr(34) + ": null, " + chr(34) + "eight" + chr(34) + ": null, " + chr(34) + "nine" + chr(34) + ": null, " + chr(34) + "ten" + chr(34) + ": null}")
    '         aa.one = 1
    '         aa.two = 2
    '         aa.three = 3
    '         aa.four = 3
    '         aa.five = 3
    '         aa.six = 3
    '         aa.seven = 3
    '         aa.eight = 3
    '         aa.nine = 3
    '         aa.ten = 3
    '     end for
    ' end function, m.callfuncTestNode)

    runTest("node clone 10", function(opCount, callfuncTestNode)
        aa = {}
        node = createObject("roSGNode", "TestAA")
        node.data = {
            one: invalid
            two: invalid
            three: invalid
            four: invalid
            five: invalid
            six: invalid
            seven: invalid
            eight: invalid
            nine: invalid
            ten: invalid
        }
        for op = 0 to opCount
            clone = node.data
            clone.one = 1
            clone.two = 2
            clone.three = 3
            clone.four = 3
            clone.five = 3
            clone.six = 3
            clone.seven = 3
            clone.eight = 3
            clone.nine = 3
            clone.ten = 3
        end for
    end function, m.callfuncTestNode)
end sub

sub callfuncTest()
    m.callfuncTestNode = CreateObject("roSGNode", "CallfuncTest")

    runTest("string", function(opCount, callfuncTestNode)
        for op = 0 to opCount
            callfuncTestNode.callfunc("testCallfunc", "click")
        end for
    end function, m.callfuncTestNode)

    runTest("int", function(opCount, callfuncTestNode)
        for op = 0 to opCount
            callfuncTestNode.callfunc("testCallfunc", 1)
        end for
    end function, m.callfuncTestNode)
end sub

sub runMulti(callback)
    for i = 0 to m.multiCount - 1
        callback()
    end for
    m.testResults = []
    callback()
end sub

sub promisePerf()
    runMulti(sub()
        runTest("Node (update)", function(opCount)
            for op = 0 to opCount
                id = "123565"
                promise = createObject("roSgNode", "Node")
                promise.addField("promiseState", "string", true)
                promise.update({
                    promiseState: "pending",
                    id: id
                })
            end for
        end function)

        runTest("Node", function(opCount)
            for op = 0 to opCount
                id = "123565"
                promise = createObject("roSgNode", "Node")
                promise.addField("promiseState", "string", true)
                promise.promiseState = "pending"
                promise.id = id
            end for
        end function)

        runTest("Promise", function(opCount)
            for op = 0 to opCount
                id = "123565"
                promise = createObject("roSgNode", "Promise")
                promise.promiseState = "pending"
                promise.id = id
            end for
        end function)

        runTest("Promise (update)", function(opCount)
            for op = 0 to opCount
                id = "123565"
                promise = createObject("roSgNode", "Promise")
                promise.update({
                    promiseState: "pending",
                    id: id
                })
            end for
        end function)

    end sub)
end sub

sub nodeCreateVsClone()

    runTest("manual", function(opCount)
        for op = 0 to opCount
            rect = createObject("roSGNode", "Rectangle")
            one = rect.createChild("Rectangle")
            one.width = 200
            one.height = 100

            two = rect.createChild("Rectangle")
            two.width = 300
            two.height = 400

            two.translation = [300, 300]
        end for
    end function)

    runTest("manual clone", function(opCount)
        rect = createObject("roSGNode", "Rectangle")
        one = rect.createChild("Rectangle")
        one.width = 200
        one.height = 100

        two = rect.createChild("Rectangle")
        two.width = 300
        two.height = 400

        two.translation = [300, 300]
        two.translation = [300, 300]
        for op = 0 to opCount
            clone = rect.clone(true)
        end for
    end function)

    runTest("createObject native component", function(opCount)
        for op = 0 to opCount
            node = createObject("roSGNode", "Rectangle")
        end for
    end function)

    runTest("clone native component", function(opCount)
        node = createObject("roSGNode", "Rectangle")
        for op = 0 to opCount
            clone = node.clone(false)
        end for
    end function)

    runTest("createObject custom component", function(opCount)
        for op = 0 to opCount
            node = createObject("roSGNode", "CustomComponent")
        end for
    end function)

    runTest("clone custom component", function(opCount)
        node = createObject("roSGNode", "CustomComponent")
        for op = 0 to opCount
            clone = node.clone(true)
        end for
        ' print clone.getChild(0) clone.getChild(1)
        clone.callfunc("DoTest")
    end function)

    runTest("createObject custom component (no init)", function(opCount)
        for op = 0 to opCount
            node = createObject("roSGNode", "CustomComponentNoInit")
        end for
    end function)

    runTest("clone custom component (no init)", function(opCount)
        node = createObject("roSGNode", "CustomComponentNoInit")
        for op = 0 to opCount
            clone = node.clone(true)
        end for
        print clone.getChild(0) clone.getChild(1)
    end function)
end sub


sub forIndexVsForEach()
    array = []
    for i = 0 to 1000
        array.push({
            id: i
        })
    end for

    runTest("for index (external)", function(opCount, array)
        for op = 0 to opCount
            for i = 0 to getCount(array)
                temp = array[i]
            end for
        end for
    end function, array)

    runTest("for index (lifted)", function(opCount, array)
        for op = 0 to opCount
            arrayCount = array.count()
            for i = 0 to arrayCount
                temp = array[i]
            end for
        end for
    end function, array)

    runTest("for index", function(opCount, array)
        for op = 0 to opCount
            for i = 0 to array.Count()
                temp = array[i]
            end for
        end for
    end function, array)

    runTest("for each", function(opCount, array)
        for op = 0 to opCount
            arrayCount = array.count()
            for each item in array
                temp = invalid
            end for
        end for
    end function, array)
end sub

function getCount(arr)
    return arr.Count()
end function

sub arrayInOrder()
    baseArray = []
    for i = 100 to 600
        baseArray.push({
            id: i
        })
    end for

    for i = 700 to 1100
        baseArray.push({
            id: i
        })
    end for

    childArrayStart = []
    childArrayMid = []
    childArrayEnd = []
    for i = 1 to 99
        childArrayStart.push({
            id: i
        })
        childArrayMid.push({
            id: 600 + i
        })
        childArrayEnd.push({
            id: 1100 + i
        })
    end for

    runTest("array append", function(opCount, baseArray)
        for i = 0 to opCount
            testArray = []
            testArray.append(baseArray)
        end for
    end function, baseArray)

    runTest("sort at beginning", function(opCount, baseArray, childArray)
        for i = 0 to opCount
            testArray = []
            testArray.append(baseArray)
            testArray.append(childArray)
            testArray.sortBy("id")
        end for
    end function, baseArray, childArrayStart)

    runTest("sort at middle", function(opCount, baseArray, childArray)
        for i = 0 to opCount
            testArray = []
            testArray.append(baseArray)
            testArray.append(childArray)
            testArray.sortBy("id")
        end for
    end function, baseArray, childArrayMid)

    runTest("sort at end", function(opCount, baseArray, childArray)
        for i = 0 to opCount
            testArray = []
            testArray.append(baseArray)
            testArray.append(childArray)
            testArray.sortBy("id")
        end for
    end function, baseArray, childArrayEnd)

    runTest("manual build at beginning", function(opCount, baseArray, childArray)
        for op = 0 to opCount
            result = []
            firstChildId = childArray[0].id
            found = false

            for each item in baseArray
                'append the child array to the result when we found the right spot
                if not found and item.id > firstChildId
                    found = true
                    for each child in childArray
                        result.push(child)
                    end for
                end if
                result.push(item)
            end for
            if found = false
                for each child in childArray
                    result.push(child)
                end for
            end if
        end for
    end function, baseArray, childArrayStart)

    runTest("manual build at beginning (array append)", function(opCount, baseArray, childArray)
        for op = 0 to opCount
            result = []
            firstChildId = childArray[0].id
            found = false

            for each item in baseArray
                'append the child array to the result when we found the right spot
                if not found and item.id > firstChildId
                    found = true
                    result.append(childArray)
                end if
                result.push(item)
            end for
            if found = false
                result.append(childArray)
            end if
        end for
    end function, baseArray, childArrayStart)


    runTest("manual build at middle", function(opCount, baseArray, childArray)
        for op = 0 to opCount
            result = []
            firstChildId = childArray[0].id
            found = false

            for each item in baseArray
                'append the child array to the result when we found the right spot
                if not found and item.id > firstChildId
                    found = true
                    for each child in childArray
                        result.push(child)
                    end for
                end if
                result.push(item)
            end for
            if found = false
                for each child in childArray
                    result.push(child)
                end for
            end if
        end for
    end function, baseArray, childArrayMid)

    runTest("manual build at middle (array append)", function(opCount, baseArray, childArray)
        for op = 0 to opCount
            result = []
            firstChildId = childArray[0].id
            found = false

            for each item in baseArray
                'append the child array to the result when we found the right spot
                if not found and item.id > firstChildId
                    found = true
                    result.append(childArray)
                end if
                result.push(item)
            end for
            if found = false
                result.append(childArray)
            end if
        end for
    end function, baseArray, childArrayMid)

    runTest("manual build at end", function(opCount, baseArray, childArray)
        for op = 0 to opCount
            result = []
            firstChildId = childArray[0].id
            found = false

            for each item in baseArray
                'append the child array to the result when we found the right spot
                if not found and item.id > firstChildId
                    found = true
                    for each child in childArray
                        result.push(child)
                    end for
                end if
                result.push(item)
            end for
            if found = false
                for each child in childArray
                    result.push(child)
                end for
            end if
        end for
    end function, baseArray, childArrayEnd)

    runTest("manual build at end (array append)", function(opCount, baseArray, childArray)
        for op = 0 to opCount
            result = []
            firstChildId = childArray[0].id
            found = false

            for each item in baseArray
                'append the child array to the result when we found the right spot
                if not found and item.id > firstChildId
                    found = true
                    result.append(childArray)
                end if
                result.push(item)
            end for
            if found = false
                result.append(childArray)
            end if
        end for
    end function, baseArray, childArrayEnd)
end sub

sub stringConcatGrouping()
    runTest("literal assignment", function(opCount)
        local = "string"
        for i = 0 to opCount
            local = "string"
        end for
    end function)

    runTest("literal assignment", function(opCount)
        local = "string"
        for i = 0 to opCount
            local = ("string")
        end for
    end function)
end sub

sub literalVsSingleAALookup()
    runTest("literal assignment", function(opCount)
        obj = {}
        for i = 0 to opCount
            obj.prop = "#FFFFFF"
        end for
    end function)

    runTest("small aa dotted get assignment", function(opCount, dictionary)
        obj = {}
        for i = 0 to opCount
            obj.prop = dictionary.zzProp
        end for
    end function, {
        zzProp: "#FFFFFF"
    })

    dictionary = {}
    for i = 0 to 10000
        dictionary["prop" + str(i)] = "#FFFFFF"
    end for
    dictionary.zzProp = "#FFFFFF"

    runTest("large aa dotted get assignment", function(opCount, dictionary)
        obj = {}
        for i = 0 to opCount
            obj.prop = dictionary.zzProp
        end for
    end function, dictionary)

    runTest("small aa indexed get assignment", function(opCount, dictionary)
        obj = {}
        for i = 0 to opCount
            obj.prop = dictionary["zzProp"]
        end for
    end function, {
        zzProp: "#FFFFFF"
    })

    dictionary = {}
    for i = 0 to 10000
        dictionary["prop" + str(i)] = "#FFFFFF"
    end for
    dictionary.zzProp = "#FFFFFF"

    runTest("large aa dotted get assignment", function(opCount, dictionary)
        obj = {}
        for i = 0 to opCount
            obj.prop = dictionary["zzProp"]
        end for
    end function, dictionary)
end sub

sub paramTypeCall()
    runTest("typed function 10 params", function(opCount)
        for i = 0 to opCount
            doNothingTyped10params(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
        end for
    end function)

    runTest("untyped function 10 params", function(opCount)
        for i = 0 to opCount
            doNothingUntyped10Params(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
        end for
    end function)

    runTest("typed function 5 params", function(opCount)
        for i = 0 to opCount
            doNothingTyped5params(0, 1, 2, 3, 4)
        end for
    end function)

    runTest("untyped function 5 params", function(opCount)
        for i = 0 to opCount
            doNothingUntyped5Params(0, 1, 2, 3, 4)
        end for
    end function)

    runTest("typed function 1 param", function(opCount)
        for i = 0 to opCount
            doNothingTyped1params(0)
        end for
    end function)

    runTest("untyped function 1 param", function(opCount)
        for i = 0 to opCount
            doNothingUntyped1Params(0)
        end for
    end function)

    runTest("empty loop", function(opCount)
        for i = 0 to opCount
            'do literally nothing
        end for
    end function)
end sub

sub doNothingTyped10params(p0 as integer, p1 as integer, p2 as integer, p3 as integer, p4 as integer, p5 as integer, p6 as integer, p7 as integer, p8 as integer, p9 as integer)
    'result = p0 + p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9
end sub

sub doNothingUntyped10Params(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9)
    'result = p0 + p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9
end sub

sub doNothingTyped5params(p0 as integer, p1 as integer, p2 as integer, p3 as integer, p4 as integer)
    'result = p0 + p1 + p2 + p3 + p4 + 5 + 6 + 7 + 8 + 9
end sub

sub doNothingUntyped5Params(p0, p1, p2, p3, p4)
    'result = p0 + p1 + p2 + p3 + p4 + 5 + 6 + 7 + 8 + 9
end sub

sub doNothingTyped1params(p0 as integer)
    'result = p0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9
end sub

sub doNothingUntyped1Params(p0)
    'result = p0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9
end sub

sub typeCall()
    runTest("type x 1", function(opCount)
        text = m.longText
        for i = 0 to opCount
            result = type(text)
        end for
    end function)

    runTest("type x 2", function(opCount)
        text = m.longText
        for i = 0 to opCount
            result = type(text)
            result = type(text)
        end for
    end function)

    runTest("type x 3", function(opCount)
        text = m.longText
        for i = 0 to opCount
            result = type(text)
            result = type(text)
            result = type(text)
        end for
    end function)

    runTest("type x 4", function(opCount)
        text = m.longText
        for i = 0 to opCount
            result = type(text)
            result = type(text)
            result = type(text)
            result = type(text)
        end for
    end function)

    runTest("type x 5", function(opCount)
        text = m.longText
        for i = 0 to opCount
            result = type(text)
            result = type(text)
            result = type(text)
            result = type(text)
            result = type(text)
        end for
    end function)

end sub

sub typePerfWithGetInterface()
    runTest("getInterface integer", function(opCount)
        value = 0
        for i = 0 to opCount
            result = getinterface(value, "ifInt") <> invalid
        end for
    end function)

    runTest("getInterface roInt", function(opCount)
        value = createObject("roInt")
        for i = 0 to opCount
            result = getinterface(value, "ifInt") <> invalid
        end for
    end function)

    runTest("type integer", function(opCount)
        value = 0
        for i = 0 to opCount
            valueType = type(value)
            result = valueType = "Integer" or valueType = "roInt"
        end for
    end function)

    runTest("type roInt", function(opCount)
        value = createObject("roInt")
        for i = 0 to opCount
            valueType = type(value)
            result = valueType = "Integer" or valueType = "roInt"
        end for
    end function)
end sub

sub intTypeCheck()
    runTest("type call each time - equality", function(opCount)
        text = m.longText
        for i = 0 to opCount
            result = type(text) = "Integer" or type(text) = "roInt"
        end for
    end function)

    runTest("lifted type call - equality", function(opCount)
        text = m.longText
        for i = 0 to opCount
            valueType = type(text)
            result = valueType = "Integer" or valueType = "roInt"
        end for
    end function)

    runTest("type call each time - instr", function(opCount)
        text = m.longText
        for i = 0 to opCount
            result = instr(1, type(text), "Integer") or type(text) = "roInt"
        end for
    end function)

    runTest("lifted type call - instr", function(opCount)
        text = m.longText
        for i = 0 to opCount
            valueType = type(text)
            result = instr(1, valueType, "Integer") or valueType = "roInt"
        end for
    end function)
end sub

' Test various ways of running `type` to see which is fastest
sub typePerf()
    runTest("duplicate type checks", function(opCount)
        value = m.longText
        for i = 0 to opCount
            result = type(value) = "Integer" or type(value) = "roInt" or type(value) = "LongInteger" or type(value) = "roInteger" or type(value) = "Float" or type(value) = "roFloat" or type(value) = "Double" or type(value) = "roDouble" or type(value) = "roIntrinsicDouble"
        end for
    end function)

    runTest("liftedType", function(opCount)
        value = m.longText
        for i = 0 to opCount
            valueType = type(value)
            result = valueType = "Integer" or valueType = "roInt" or valueType = "LongInteger" or valueType = "roInteger" or valueType = "Float" or valueType = "roFloat" or valueType = "Double" or valueType = "roDouble" or valueType = "roIntrinsicDouble"
        end for
    end function)

    runTest("liftedType instr", function(opCount)
        value = m.longText
        for i = 0 to opCount
            valueType = type(value)
            result = instr(1, valueType, "Int") <> 0 or instr(1, valueType, "Float") <> 0 or instr(1, valueType, "Double") <> 0
        end for
    end function)

    runTest("helper", function(opCount)
        value = m.longText
        for i = 0 to opCount
            result = bslib_isNumber(type(value))
        end for
    end function)

    runTest("inline m assignment", function(opCount)
        value = m.longText
        for i = 0 to opCount
            result = (function(valueType)
                m.valueType = valueType
                return true
            end function)(type(value)) and (m.valueType = "Integer" or m.valueType = "roInt" or m.valueType = "LongInteger" or m.valueType = "roInteger" or m.valueType = "Float" or m.valueType = "roFloat" or m.valueType = "Double" or m.valueType = "roDouble" or m.valueType = "roIntrinsicDouble")
        end for
    end function)
end sub

function bslib_isNumber(valueType as dynamic)
    return valueType = "Integer" or valueType = "roInt" or valueType = "LongInteger" or valueType = "roInteger" or valueType = "Float" or valueType = "roFloat" or valueType = "Double" or valueType = "roDouble" or valueType = "roIntrinsicDouble"
end function

function bslib_isBoolean(valType as dynamic)
    return valType = "Boolean" or valType = "roBoolean"
end function

sub md5()
    runTest("md5", function(opCount)
        text = "kydjunsbhrtajaftfvqujclkuvfumwhzdwnwwxgpfzitrczecybufxzfkyazvrufhkeatqpwaegxjuxnvvbmhlbejxezfcbsxufsyvdcbzmwqtmsvudlejtkupinzwnsfglefnvhekehoskwsqoojanilgwrbnmjutwkolpdkajahqmetipdygxufqkudbvffrtuzmrkzzqcdicncwlckebpxbqsykuysduvfnybtdlurqxebezixelyxafelqjburwheezfzsdqwingdfgfjwacfffnpvjpcgbortelivbwqnaviwgzpjuhiwqrlemnxryozqxigaevzmtkyqidmtxegvzndydtxnzlpkwsmkexvbdiodntfarpdpwcqxjcksuomfdpazezdmlzlbmunrwlaulffptwkeunyiegscqxxwsjibvisvjrovuwctvurewqoinmvyizlnbmguwrbtwfbcghlmmvbysaedwzolrnohvksgesocanisjrmcffwwxkfokicyogajpxgvkzcctenbgrxqwcdciovcmwropqdtxjgmfggazopudrxcgnlprlftmsmmhszauoemihxnmcuwlckxfqottrcagzocnhtfjhfayrvjlssxfiotxhwulbprefgckmeohwdjxpclxkxiqiqffpcmbbtkibsyzhgvgbdanuxcfbxqohnnifuidfnznmpirbxebelcqsntoheonlbuwryiiunzvkllrltgeagjhdbsbdwbufxwopxrvibphyfnznzvzoqdawlfzhkipiwfrnyvtpikdbnccsuvsikatzwtyjocdndjxkjxejtmaxvylnaatbmszyvhjpjldhrcydmbwfgjxlataglpjpufxdxyehvmnraselsyxdgxnlvavsifgdnjgbedkmtjgzbyvuqyxcfxtedfflsbiamnfnxlziexhvatkunxdooareuwxhbyekqwbsfmgaxhrputsmacemqvvralwuxncvqngbdfktynlkrbrzykafxmyqrjizrfhxoenbmjqmjdnijcylsznxmuqmoekicveepflqupulliygxpcbchhcshbjhfrmvcfvawqaakkwymtwmzhonrmyqzcivubrxdhywankmesrzxlaavnkrdgicxdyqxmotdqjvofywkqwgdpzaspfkkzqiqxqodtwfptclgxrnilfvzvivjyoiulyitkfjilxergwimvfpjibftrewviimystoijbplpgcwkncvtjdmnqsaiyjbwsdbjcztzdjpkesyjcumncsdjzypexjnksprxwhskoyhdcqqjihlvqtyshehvlnwmtnjyxiecbzhltqqriajyvnbhmnbwhtnmomuuornbeqrwihqznutpifzojyhjaowdlgpbxvsuoihuxncadbfaameigordaanfivnihglhkgndfidlsgqbxfctgmottlujdtoenjqamjjytqjrqtgsrafqexynwcsmxrjpydqynpeezqxnrdnwmzmzvmwczqxeccqcjbxhehavyokqxnkzgmrimhenfnnavkimbyluabcavlwfgbuxvuvnaubfpqbrdjkoneauuycnakqagwetnirhvloksilmyjimfwmzzkdqxywphfbkjeszrkkeksrselgxqbkjqxihqiyvchirqpbkiychljdyrgtwlpgcmtoezfjpcebpzdrlwcndwkmkgisgjjnpzqnsmfucoskliuiqqmvpkktvicqgyshobkzadjqogauczwafxlavhmtsnnrlanrxtwoqwjluxcjxoxatlakldtprsjjtpawmloruuvfzutrordjhdstkblwpzbagpcojkrszrsznzywyleaafxigxgnipuukepieukoztfphpnwbwubvpgahzjjagosiyjkluqcydatptvszhuibgzqbiriaslrvftllgmrjnnkkyxnnbrsntujkqstfvvfqreyqirenhhruysbohaqelaecogjblfpeohobisoxxazcppbcgwzigdjwtmkrurbpaulpgdmwjgsldkwxkvuohymucwgqytbyvnuvorzdcncqakbezqzvchuphaurucvydvkpmduqmjeiuqslzjwxgruaqtndlfcnqmgtieexdbdizsznxofwglprupanftxgecqryifuaywphzvxqvcdnqmhtrxpodlwigcvjkcltgsvfpizqzdlpmgtkyblhqxdnggphctlqcpledhhiszfnxzlurvczzaqonljacehmeieupoecztngpqekdplaxnvbgjowgiyssgqjnicfjpsjshwbmkglbxjbgwkcxjmecthrgvugnluivmuecgkxzdfbytuwcoutgbyqsefzbubtdvuxzqbhrteqyyrekngayhlmsdrgdwalblifmvtoodgtuybitqgkcbpvkpgbxyfsspvbzpsxkynobvrdthgcqewnbqyefkhdwljqktfstxtkwaviibpabynthkoikcvutckfouatjhosvmfcvnazwyjnlbvjcwceyzmnubzixtdnelfferpnttghihyratydsdjdgtwgeuvlmgscfdmbejnxjcoczabwrxteisjxdfhiqrnlvvfpwvojmkoqdwojaggnmnwddyihfcoobigfsqpqblbgffbkzkgmsbfxwciwbdzyfqibtwpsanokpokzggbzqzlqhnshvpfwrtisejkswhzcfgwhznwkwejjuwxyvttnvkklizilmythgcvnbjslbvzjhprqlouukswsoecngzarhqexlmwoqnjfelxhjzrsgpqbsidktsksrfukerarrlwdsewioganokwbacwewqdyazrupnjrtmhoorogxeylywyhmoemrbduokxogfdwpbjvyilripcbswloykysphwjbfblkczxuvrzieuhsrtishpcqoyjxcnivvtkxcwnicxgqvuddfwdpluiqtjqfgovngvevzsijivyxxzoajfxgngwxawnrrhyfdfebrbtnxrtgajlmbkgizdozeypaddyynebqrowtkrdhcdxplavwyfnkkhmkoscdrvvizsnyujvmialhwjvnpzugccxrkogalrpjoajywkkgedcvrgljrbdwjlvaqbfzpjkanpvquxpifklcxthypyffyufqjctkjvnmsbrvdvdxmegjhmvadkforlftmbphhsduibqirocamanvuucujuculsaidydgehfkoipwkezodjqqdtyddffrxtkrqwfsojtnuuwlnsncqmgbpobdzhvxpajxvtfylhtzagllcgqzyiuhdiaxpuqxuhfzqhmhivqgkbsfgqubomtqwazldrzfcalvovzrojkzgiilkusnnggqpdsjsuosttevexrlatqoxxulxxrdwecgvanhsgrpcwsolyacsyywtbekgvjkrigimndlmtnueyabiaawipwdxqbhjmzzmwutqrbqmmpjeqelollqnvkwumvooludxrhdffcnlwhaihjpqjmhvjesyfqrbszanjgmfefpbojhkisuqvizigzripxvsrvgnpnmhmcdgwsjdrkvucqfpxlbfjzbbzcbaotkxavrrahirdvkzvkkdkzuczqizmfbjtorrbzrlfzrlvmntzbfarscmffrjkyhfbnekecdmbbipleaprfqkttyvamdtygnoccjqtiwufndbugdystjhskbrhicefvqginyrtivrmlrfzjrulfsvdunaahwlczngqydkuhwbayhjmemgcyironnomlqkrwxvqlpsrcvhfrqasirfnidxfszaixizoxqrugkqptoyeryqclgpphgtrearzcrgyyzmfxsysmtbdbciahqguwkxmyrmmmiiqjidmguzbprtaauunkzsvocswehrntlzvtvjquoyyipunsyqlzhavgdknnkyzhpunkgpphchdiurdpjsyfjblyqovujganrvsliqhjxchhpersselllpejipdpzazrzsmvepucfvtkxjokzcpwfvrksewtmhnhrhtbsdnkxwzhqkljgvactevxrutdbovtwkbkslsbtzacftencilzfkomuismorquhapjxbovyvtrtxlrfwobtrwzpvwjexemkywrjnvvwdfyuzwjbdmrarwwkvtaaebymlcentfhfyftrquqzquqfcnemojpjujqnmcuftulyvyzdzzsjcqrcwtucskqotbjhdakubdfawtbmxvtxqnowpaccqyrljlsfgszfwkucaduetzfzotkfavfdfpilrmybwzrdgafllcgpuzqmtxkbljunzqebimusrevpomqzpfhpflqxjsebmgmbvotnonrudfixepkveqceredjwttlmhoqkipfhubnkmemrrmggaqbumbdqmmndqkbzgoagbkgxuukaoxpegfjyzizkgmmycptufoqjpofvhnvplvdedqhsmjgaiglassmrlrrrrudwkiuzmkkyyfqrnbjtczvootntkvuwhtrvbmmauwgsvifbdoxrnmvvwtysrgspkrgujkjbpomlnkvgssinkxhduoyhxoqgtdgfhnwjgbbvpyotrejadpovopcwkrviwmbaoydbinhdwnfsokcijukguchntkzmaavbfgiruxsxyukizarkdlyadukpwcifdbujsipuueamocrcsoeksejirdfxfhxyqvnseljweqzkvesgpviswrcvzgcgbjgsiquljznvwaeajsdyidlbojnmnhobqrcxytmtlbabxfcmzpefnjcoxhqinmfjhcytenyjjwdlnudakklpbmuddkrgdoiboekmpiuyphtoakybyfnvhudxoqrbcacqacaayqprbjqkxboruapsdgjsolbibviqpeyahqywiygdjmhdrdtrafegejizjptzrarxbathcwqmumsoroyixdbqevehujycytgbbnufdinebldnis"
        for i = 0 to opCount
            bytes = createObject("roByteArray")
            bytes.fromAsciiString(text)
            evpDigest = createObject("roEVPDigest")
            evpDigest.setup("md5")
            result = evpDigest.process(bytes)
        end for
    end function)
end sub

sub stringVsArrayKeyLookups()
    json = {
        user: {
            favorites: [
                {
                    isActive: true
                }
            ]
        }
    }
    runTest("string split", sub(opCount, json, path)
        getPath = function(content as object, path as string, default = invalid as dynamic, disableIndexing = false as boolean) as dynamic
            part = invalid

            if path <> invalid
                parts = path.split(".")
                numParts = parts.count()
                i = 0

                part = content
                while i < numParts and part <> invalid
                    if not disableIndexing and (parts[i] = "0" or (parts[i].toInt() <> 0 and parts[i].toInt().toStr() = parts[i]))
                        if type(part) <> "<uninitialized>" and part <> invalid and GetInterface(part, "ifArray") <> invalid
                            part = part[parts[i].toInt()]
                        else if type(part) <> "<uninitialized>" and part <> invalid and GetInterface(part, "ifAssociativeArray") <> invalid
                            part = part[parts[i]]
                        else if type(part) = "roSGNode"
                            part = part.getChild(parts[i].toInt())
                        else
                            part = invalid
                        end if
                    else
                        if type(part) <> "<uninitialized>" and part <> invalid and GetInterface(part, "ifAssociativeArray") <> invalid
                            part = part[parts[i]]
                        else
                            part = invalid
                        end if
                    end if
                    i++
                end while
            end if

            if part <> invalid
                return part
            else
                return default
            end if
        end function

        for i = 0 to opCount
            getPath(json, path)
        end for
    end sub, json, "user.favorites.0.isActive")

    runTest("already split", sub(opCount, json, keys)
        getPath = function(content as object, parts, default = invalid as dynamic, disableIndexing = false as boolean) as dynamic
            part = invalid

            if parts <> invalid
                numParts = parts.count()
                i = 0

                part = content
                while i < numParts and part <> invalid
                    if not disableIndexing and (parts[i] = "0" or (parts[i].toInt() <> 0 and parts[i].toInt().toStr() = parts[i]))
                        if type(part) <> "<uninitialized>" and part <> invalid and GetInterface(part, "ifArray") <> invalid
                            part = part[parts[i].toInt()]
                        else if type(part) <> "<uninitialized>" and part <> invalid and GetInterface(part, "ifAssociativeArray") <> invalid
                            part = part[parts[i]]
                        else if type(part) = "roSGNode"
                            part = part.getChild(parts[i].toInt())
                        else
                            part = invalid
                        end if
                    else
                        if type(part) <> "<uninitialized>" and part <> invalid and GetInterface(part, "ifAssociativeArray") <> invalid
                            part = part[parts[i]]
                        else
                            part = invalid
                        end if
                    end if
                    i++
                end while
            end if

            if part <> invalid
                return part
            else
                return default
            end if
        end function
        for i = 0 to opCount
            getPath(json, keys)
        end for
    end sub, json, ["user", "favorites", "0", "isActive"])
end sub


function getOpsPerSec(startDate, endDate, ops)
    startMs = getMilliseconds(startDate)
    endMs = getMilliseconds(endDate)
    seconds = (endMs - startMs) / 1000
    opsPerSec = ops / seconds
    return opsPerSec
end function

function getMilliseconds(date)
    result = 0
    result += date.GetMinutes() * 60 * 1000
    result += date.GetSeconds() * 1000
    result += date.GetMilliseconds()
    return result
end function

function numberToString(num)
    result = ""
    i = 0
    while num > 1
        loopNum = (num mod 10).ToStr().Trim()
        result = loopNum + result
        num = num / 10
        i++
        if i mod 3 = 0 and num > 1 then
            result = "," + result
        end if
    end while
    result = result + "." + ((num * 10) mod 1).ToStr().Trim() + ((num * 100) mod 1).ToStr().Trim()
    return result
end function

'
' Run a single test.
' @param name - the name of the test
' @param testFn - reference to the test to run
' @param args - an array of parameters to pass as arguments to the test function
'
sub runTest(name as string, testFunc as function, arg1 = invalid, arg2 = invalid, arg3 = invalid, arg4 = invalid)
    RunGarbageCollector()
    print name; " (RUNNING)"

    opCount = m.opCount
    if arg4 <> invalid
        startTime = CreateObject("roDateTime")
        testFunc(opCount, arg1, arg2, arg3, arg4)
        endTime = CreateObject("roDateTime")
    else if arg3 <> invalid
        startTime = CreateObject("roDateTime")
        testFunc(opCount, arg1, arg2, arg3)
        endTime = CreateObject("roDateTime")
    else if arg2 <> invalid
        startTime = CreateObject("roDateTime")
        testFunc(opCount, arg1, arg2)
        endTime = CreateObject("roDateTime")
    else if arg1 <> invalid
        startTime = CreateObject("roDateTime")
        testFunc(opCount, arg1)
        endTime = CreateObject("roDateTime")
    else
        startTime = CreateObject("roDateTime")
        testFunc(opCount)
        endTime = CreateObject("roDateTime")
    end if
    result = {
        name: name
        opsPerSec: getOpsPerSec(startTime, endTime, opCount)
    }
    print name; " (DONE)"
    m.testResults.push(result)
    RunGarbageCollector()
end sub

function printResults(results)
    print ""
    print "RESULTS:"
    print padRight("", 50, "_")
    print ""
    highestOpsPerSec = results[0].opsPerSec
    lowestOpsPerSec = results[0].opsPerSec
    opsPerSecMaxLen = 0
    nameLengthMaxLen = 0
    for each result in results
        'calculate slowest
        if result.opsPerSec < lowestOpsPerSec
            lowestOpsPerSec = result.opsPerSec
        end if

        'calculate highest ops/sec
        if result.opsPerSec > highestOpsPerSec
            highestOpsPerSec = result.opsPerSec
        end if

        'calculate logest ops/sec string
        opsPerSecTextLength = numberToString(result.opsPerSec).Len()
        if opsPerSecTextLength > opsPerSecMaxLen
            opsPerSecMaxLen = opsPerSecTextLength
        end if

        'calculate longest name
        if result.name.Len() > nameLengthMaxLen
            nameLengthMaxLen = result.name.Len()
        end if

    end for
    for each result in results
        postfix = ""
        if result.opsPerSec = highestOpsPerSec then
            postfix = " (fastest)"
        end if
        if result.opsPerSec = lowestOpsPerSec then
            postfix = " (slowest)"
        end if
        printResult(result, nameLengthMaxLen + 5, opsPerSecMaxLen, postfix)
    end for
end function

'
' Print a single test result
'
sub printResult(result, namePadding = 1, opsPadding = 0, postfix = "")
    print padRight(result.name + ": ", namePadding, "-"); " "; padLeft(numberToString(result.opsPerSec), opsPadding, " "); " ops/sec"; postfix
end sub

function padRight(value as string, padLength = 2 as integer, paddingCharacter = "0" as dynamic) as string
    while value.len() < padLength
        value += paddingCharacter
    end while
    return value
end function

function padLeft(value as string, padLength = 2 as integer, paddingCharacter = "0" as dynamic) as string
    while value.len() < padLength
        value = paddingCharacter + value
    end while
    return value
end function

sub noop()
end sub
