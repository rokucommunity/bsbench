sub main()
    runAllTests()
end sub

sub runAllTests()

    print "Tests starting"
    m.opCount = 100000
    m.testResults = []

    typePerf()

    'md5()
    'stringVsArrayKeyLookups()

    printResults(m.testResults)

    startTime = CreateObject("roDateTime")
    'the print buffer isn't flushed when the app dies, so spin till it flushes
    print " "
    while CreateObject("roDateTime").AsSeconds() - startTime.AsSeconds() < 1
    end while
end sub

' Test various ways of running `type` to see which is fastest
sub typePerf()
    runTest("doubleType", function(opCount)
        text = "kydjunsbhrtajaftfvqujclkuvfumwhzdwnwwxgpfzitrczecybufxzfkyazvrufhkeatqpwaegxjuxnvvbmhlbejxezfcbsxufsyvdcbzmwqtmsvudlejtkupinzwnsfglefnvhekehoskwsqoojanilgwrbnmjutwkolpdkajahqmetipdygxufqkudbvffrtuzmrkzzqcdicncwlckebpxbqsykuysduvfnybtdlurqxebezixelyxafelqjburwheezfzsdqwingdfgfjwacfffnpvjpcgbortelivbwqnaviwgzpjuhiwqrlemnxryozqxigaevzmtkyqidmtxegvzndydtxnzlpkwsmkexvbdiodntfarpdpwcqxjcksuomfdpazezdmlzlbmunrwlaulffptwkeunyiegscqxxwsjibvisvjrovuwctvurewqoinmvyizlnbmguwrbtwfbcghlmmvbysaedwzolrnohvksgesocanisjrmcffwwxkfokicyogajpxgvkzcctenbgrxqwcdciovcmwropqdtxjgmfggazopudrxcgnlprlftmsmmhszauoemihxnmcuwlckxfqottrcagzocnhtfjhfayrvjlssxfiotxhwulbprefgckmeohwdjxpclxkxiqiqffpcmbbtkibsyzhgvgbdanuxcfbxqohnnifuidfnznmpirbxebelcqsntoheonlbuwryiiunzvkllrltgeagjhdbsbdwbufxwopxrvibphyfnznzvzoqdawlfzhkipiwfrnyvtpikdbnccsuvsikatzwtyjocdndjxkjxejtmaxvylnaatbmszyvhjpjldhrcydmbwfgjxlataglpjpufxdxyehvmnraselsyxdgxnlvavsifgdnjgbedkmtjgzbyvuqyxcfxtedfflsbiamnfnxlziexhvatkunxdooareuwxhbyekqwbsfmgaxhrputsmacemqvvralwuxncvqngbdfktynlkrbrzykafxmyqrjizrfhxoenbmjqmjdnijcylsznxmuqmoekicveepflqupulliygxpcbchhcshbjhfrmvcfvawqaakkwymtwmzhonrmyqzcivubrxdhywankmesrzxlaavnkrdgicxdyqxmotdqjvofywkqwgdpzaspfkkzqiqxqodtwfptclgxrnilfvzvivjyoiulyitkfjilxergwimvfpjibftrewviimystoijbplpgcwkncvtjdmnqsaiyjbwsdbjcztzdjpkesyjcumncsdjzypexjnksprxwhskoyhdcqqjihlvqtyshehvlnwmtnjyxiecbzhltqqriajyvnbhmnbwhtnmomuuornbeqrwihqznutpifzojyhjaowdlgpbxvsuoihuxncadbfaameigordaanfivnihglhkgndfidlsgqbxfctgmottlujdtoenjqamjjytqjrqtgsrafqexynwcsmxrjpydqynpeezqxnrdnwmzmzvmwczqxeccqcjbxhehavyokqxnkzgmrimhenfnnavkimbyluabcavlwfgbuxvuvnaubfpqbrdjkoneauuycnakqagwetnirhvloksilmyjimfwmzzkdqxywphfbkjeszrkkeksrselgxqbkjqxihqiyvchirqpbkiychljdyrgtwlpgcmtoezfjpcebpzdrlwcndwkmkgisgjjnpzqnsmfucoskliuiqqmvpkktvicqgyshobkzadjqogauczwafxlavhmtsnnrlanrxtwoqwjluxcjxoxatlakldtprsjjtpawmloruuvfzutrordjhdstkblwpzbagpcojkrszrsznzywyleaafxigxgnipuukepieukoztfphpnwbwubvpgahzjjagosiyjkluqcydatptvszhuibgzqbiriaslrvftllgmrjnnkkyxnnbrsntujkqstfvvfqreyqirenhhruysbohaqelaecogjblfpeohobisoxxazcppbcgwzigdjwtmkrurbpaulpgdmwjgsldkwxkvuohymucwgqytbyvnuvorzdcncqakbezqzvchuphaurucvydvkpmduqmjeiuqslzjwxgruaqtndlfcnqmgtieexdbdizsznxofwglprupanftxgecqryifuaywphzvxqvcdnqmhtrxpodlwigcvjkcltgsvfpizqzdlpmgtkyblhqxdnggphctlqcpledhhiszfnxzlurvczzaqonljacehmeieupoecztngpqekdplaxnvbgjowgiyssgqjnicfjpsjshwbmkglbxjbgwkcxjmecthrgvugnluivmuecgkxzdfbytuwcoutgbyqsefzbubtdvuxzqbhrteqyyrekngayhlmsdrgdwalblifmvtoodgtuybitqgkcbpvkpgbxyfsspvbzpsxkynobvrdthgcqewnbqyefkhdwljqktfstxtkwaviibpabynthkoikcvutckfouatjhosvmfcvnazwyjnlbvjcwceyzmnubzixtdnelfferpnttghihyratydsdjdgtwgeuvlmgscfdmbejnxjcoczabwrxteisjxdfhiqrnlvvfpwvojmkoqdwojaggnmnwddyihfcoobigfsqpqblbgffbkzkgmsbfxwciwbdzyfqibtwpsanokpokzggbzqzlqhnshvpfwrtisejkswhzcfgwhznwkwejjuwxyvttnvkklizilmythgcvnbjslbvzjhprqlouukswsoecngzarhqexlmwoqnjfelxhjzrsgpqbsidktsksrfukerarrlwdsewioganokwbacwewqdyazrupnjrtmhoorogxeylywyhmoemrbduokxogfdwpbjvyilripcbswloykysphwjbfblkczxuvrzieuhsrtishpcqoyjxcnivvtkxcwnicxgqvuddfwdpluiqtjqfgovngvevzsijivyxxzoajfxgngwxawnrrhyfdfebrbtnxrtgajlmbkgizdozeypaddyynebqrowtkrdhcdxplavwyfnkkhmkoscdrvvizsnyujvmialhwjvnpzugccxrkogalrpjoajywkkgedcvrgljrbdwjlvaqbfzpjkanpvquxpifklcxthypyffyufqjctkjvnmsbrvdvdxmegjhmvadkforlftmbphhsduibqirocamanvuucujuculsaidydgehfkoipwkezodjqqdtyddffrxtkrqwfsojtnuuwlnsncqmgbpobdzhvxpajxvtfylhtzagllcgqzyiuhdiaxpuqxuhfzqhmhivqgkbsfgqubomtqwazldrzfcalvovzrojkzgiilkusnnggqpdsjsuosttevexrlatqoxxulxxrdwecgvanhsgrpcwsolyacsyywtbekgvjkrigimndlmtnueyabiaawipwdxqbhjmzzmwutqrbqmmpjeqelollqnvkwumvooludxrhdffcnlwhaihjpqjmhvjesyfqrbszanjgmfefpbojhkisuqvizigzripxvsrvgnpnmhmcdgwsjdrkvucqfpxlbfjzbbzcbaotkxavrrahirdvkzvkkdkzuczqizmfbjtorrbzrlfzrlvmntzbfarscmffrjkyhfbnekecdmbbipleaprfqkttyvamdtygnoccjqtiwufndbugdystjhskbrhicefvqginyrtivrmlrfzjrulfsvdunaahwlczngqydkuhwbayhjmemgcyironnomlqkrwxvqlpsrcvhfrqasirfnidxfszaixizoxqrugkqptoyeryqclgpphgtrearzcrgyyzmfxsysmtbdbciahqguwkxmyrmmmiiqjidmguzbprtaauunkzsvocswehrntlzvtvjquoyyipunsyqlzhavgdknnkyzhpunkgpphchdiurdpjsyfjblyqovujganrvsliqhjxchhpersselllpejipdpzazrzsmvepucfvtkxjokzcpwfvrksewtmhnhrhtbsdnkxwzhqkljgvactevxrutdbovtwkbkslsbtzacftencilzfkomuismorquhapjxbovyvtrtxlrfwobtrwzpvwjexemkywrjnvvwdfyuzwjbdmrarwwkvtaaebymlcentfhfyftrquqzquqfcnemojpjujqnmcuftulyvyzdzzsjcqrcwtucskqotbjhdakubdfawtbmxvtxqnowpaccqyrljlsfgszfwkucaduetzfzotkfavfdfpilrmybwzrdgafllcgpuzqmtxkbljunzqebimusrevpomqzpfhpflqxjsebmgmbvotnonrudfixepkveqceredjwttlmhoqkipfhubnkmemrrmggaqbumbdqmmndqkbzgoagbkgxuukaoxpegfjyzizkgmmycptufoqjpofvhnvplvdedqhsmjgaiglassmrlrrrrudwkiuzmkkyyfqrnbjtczvootntkvuwhtrvbmmauwgsvifbdoxrnmvvwtysrgspkrgujkjbpomlnkvgssinkxhduoyhxoqgtdgfhnwjgbbvpyotrejadpovopcwkrviwmbaoydbinhdwnfsokcijukguchntkzmaavbfgiruxsxyukizarkdlyadukpwcifdbujsipuueamocrcsoeksejirdfxfhxyqvnseljweqzkvesgpviswrcvzgcgbjgsiquljznvwaeajsdyidlbojnmnhobqrcxytmtlbabxfcmzpefnjcoxhqinmfjhcytenyjjwdlnudakklpbmuddkrgdoiboekmpiuyphtoakybyfnvhudxoqrbcacqacaayqprbjqkxboruapsdgjsolbibviqpeyahqywiygdjmhdrdtrafegejizjptzrarxbathcwqmumsoroyixdbqevehujycytgbbnufdinebldnis"
        for i = 0 to opCount
            result = type(text) = "Boolean" or type(text) = "roBoolean"
        end for
    end function)

    runTest("liftedType", function(opCount)
        text = "kydjunsbhrtajaftfvqujclkuvfumwhzdwnwwxgpfzitrczecybufxzfkyazvrufhkeatqpwaegxjuxnvvbmhlbejxezfcbsxufsyvdcbzmwqtmsvudlejtkupinzwnsfglefnvhekehoskwsqoojanilgwrbnmjutwkolpdkajahqmetipdygxufqkudbvffrtuzmrkzzqcdicncwlckebpxbqsykuysduvfnybtdlurqxebezixelyxafelqjburwheezfzsdqwingdfgfjwacfffnpvjpcgbortelivbwqnaviwgzpjuhiwqrlemnxryozqxigaevzmtkyqidmtxegvzndydtxnzlpkwsmkexvbdiodntfarpdpwcqxjcksuomfdpazezdmlzlbmunrwlaulffptwkeunyiegscqxxwsjibvisvjrovuwctvurewqoinmvyizlnbmguwrbtwfbcghlmmvbysaedwzolrnohvksgesocanisjrmcffwwxkfokicyogajpxgvkzcctenbgrxqwcdciovcmwropqdtxjgmfggazopudrxcgnlprlftmsmmhszauoemihxnmcuwlckxfqottrcagzocnhtfjhfayrvjlssxfiotxhwulbprefgckmeohwdjxpclxkxiqiqffpcmbbtkibsyzhgvgbdanuxcfbxqohnnifuidfnznmpirbxebelcqsntoheonlbuwryiiunzvkllrltgeagjhdbsbdwbufxwopxrvibphyfnznzvzoqdawlfzhkipiwfrnyvtpikdbnccsuvsikatzwtyjocdndjxkjxejtmaxvylnaatbmszyvhjpjldhrcydmbwfgjxlataglpjpufxdxyehvmnraselsyxdgxnlvavsifgdnjgbedkmtjgzbyvuqyxcfxtedfflsbiamnfnxlziexhvatkunxdooareuwxhbyekqwbsfmgaxhrputsmacemqvvralwuxncvqngbdfktynlkrbrzykafxmyqrjizrfhxoenbmjqmjdnijcylsznxmuqmoekicveepflqupulliygxpcbchhcshbjhfrmvcfvawqaakkwymtwmzhonrmyqzcivubrxdhywankmesrzxlaavnkrdgicxdyqxmotdqjvofywkqwgdpzaspfkkzqiqxqodtwfptclgxrnilfvzvivjyoiulyitkfjilxergwimvfpjibftrewviimystoijbplpgcwkncvtjdmnqsaiyjbwsdbjcztzdjpkesyjcumncsdjzypexjnksprxwhskoyhdcqqjihlvqtyshehvlnwmtnjyxiecbzhltqqriajyvnbhmnbwhtnmomuuornbeqrwihqznutpifzojyhjaowdlgpbxvsuoihuxncadbfaameigordaanfivnihglhkgndfidlsgqbxfctgmottlujdtoenjqamjjytqjrqtgsrafqexynwcsmxrjpydqynpeezqxnrdnwmzmzvmwczqxeccqcjbxhehavyokqxnkzgmrimhenfnnavkimbyluabcavlwfgbuxvuvnaubfpqbrdjkoneauuycnakqagwetnirhvloksilmyjimfwmzzkdqxywphfbkjeszrkkeksrselgxqbkjqxihqiyvchirqpbkiychljdyrgtwlpgcmtoezfjpcebpzdrlwcndwkmkgisgjjnpzqnsmfucoskliuiqqmvpkktvicqgyshobkzadjqogauczwafxlavhmtsnnrlanrxtwoqwjluxcjxoxatlakldtprsjjtpawmloruuvfzutrordjhdstkblwpzbagpcojkrszrsznzywyleaafxigxgnipuukepieukoztfphpnwbwubvpgahzjjagosiyjkluqcydatptvszhuibgzqbiriaslrvftllgmrjnnkkyxnnbrsntujkqstfvvfqreyqirenhhruysbohaqelaecogjblfpeohobisoxxazcppbcgwzigdjwtmkrurbpaulpgdmwjgsldkwxkvuohymucwgqytbyvnuvorzdcncqakbezqzvchuphaurucvydvkpmduqmjeiuqslzjwxgruaqtndlfcnqmgtieexdbdizsznxofwglprupanftxgecqryifuaywphzvxqvcdnqmhtrxpodlwigcvjkcltgsvfpizqzdlpmgtkyblhqxdnggphctlqcpledhhiszfnxzlurvczzaqonljacehmeieupoecztngpqekdplaxnvbgjowgiyssgqjnicfjpsjshwbmkglbxjbgwkcxjmecthrgvugnluivmuecgkxzdfbytuwcoutgbyqsefzbubtdvuxzqbhrteqyyrekngayhlmsdrgdwalblifmvtoodgtuybitqgkcbpvkpgbxyfsspvbzpsxkynobvrdthgcqewnbqyefkhdwljqktfstxtkwaviibpabynthkoikcvutckfouatjhosvmfcvnazwyjnlbvjcwceyzmnubzixtdnelfferpnttghihyratydsdjdgtwgeuvlmgscfdmbejnxjcoczabwrxteisjxdfhiqrnlvvfpwvojmkoqdwojaggnmnwddyihfcoobigfsqpqblbgffbkzkgmsbfxwciwbdzyfqibtwpsanokpokzggbzqzlqhnshvpfwrtisejkswhzcfgwhznwkwejjuwxyvttnvkklizilmythgcvnbjslbvzjhprqlouukswsoecngzarhqexlmwoqnjfelxhjzrsgpqbsidktsksrfukerarrlwdsewioganokwbacwewqdyazrupnjrtmhoorogxeylywyhmoemrbduokxogfdwpbjvyilripcbswloykysphwjbfblkczxuvrzieuhsrtishpcqoyjxcnivvtkxcwnicxgqvuddfwdpluiqtjqfgovngvevzsijivyxxzoajfxgngwxawnrrhyfdfebrbtnxrtgajlmbkgizdozeypaddyynebqrowtkrdhcdxplavwyfnkkhmkoscdrvvizsnyujvmialhwjvnpzugccxrkogalrpjoajywkkgedcvrgljrbdwjlvaqbfzpjkanpvquxpifklcxthypyffyufqjctkjvnmsbrvdvdxmegjhmvadkforlftmbphhsduibqirocamanvuucujuculsaidydgehfkoipwkezodjqqdtyddffrxtkrqwfsojtnuuwlnsncqmgbpobdzhvxpajxvtfylhtzagllcgqzyiuhdiaxpuqxuhfzqhmhivqgkbsfgqubomtqwazldrzfcalvovzrojkzgiilkusnnggqpdsjsuosttevexrlatqoxxulxxrdwecgvanhsgrpcwsolyacsyywtbekgvjkrigimndlmtnueyabiaawipwdxqbhjmzzmwutqrbqmmpjeqelollqnvkwumvooludxrhdffcnlwhaihjpqjmhvjesyfqrbszanjgmfefpbojhkisuqvizigzripxvsrvgnpnmhmcdgwsjdrkvucqfpxlbfjzbbzcbaotkxavrrahirdvkzvkkdkzuczqizmfbjtorrbzrlfzrlvmntzbfarscmffrjkyhfbnekecdmbbipleaprfqkttyvamdtygnoccjqtiwufndbugdystjhskbrhicefvqginyrtivrmlrfzjrulfsvdunaahwlczngqydkuhwbayhjmemgcyironnomlqkrwxvqlpsrcvhfrqasirfnidxfszaixizoxqrugkqptoyeryqclgpphgtrearzcrgyyzmfxsysmtbdbciahqguwkxmyrmmmiiqjidmguzbprtaauunkzsvocswehrntlzvtvjquoyyipunsyqlzhavgdknnkyzhpunkgpphchdiurdpjsyfjblyqovujganrvsliqhjxchhpersselllpejipdpzazrzsmvepucfvtkxjokzcpwfvrksewtmhnhrhtbsdnkxwzhqkljgvactevxrutdbovtwkbkslsbtzacftencilzfkomuismorquhapjxbovyvtrtxlrfwobtrwzpvwjexemkywrjnvvwdfyuzwjbdmrarwwkvtaaebymlcentfhfyftrquqzquqfcnemojpjujqnmcuftulyvyzdzzsjcqrcwtucskqotbjhdakubdfawtbmxvtxqnowpaccqyrljlsfgszfwkucaduetzfzotkfavfdfpilrmybwzrdgafllcgpuzqmtxkbljunzqebimusrevpomqzpfhpflqxjsebmgmbvotnonrudfixepkveqceredjwttlmhoqkipfhubnkmemrrmggaqbumbdqmmndqkbzgoagbkgxuukaoxpegfjyzizkgmmycptufoqjpofvhnvplvdedqhsmjgaiglassmrlrrrrudwkiuzmkkyyfqrnbjtczvootntkvuwhtrvbmmauwgsvifbdoxrnmvvwtysrgspkrgujkjbpomlnkvgssinkxhduoyhxoqgtdgfhnwjgbbvpyotrejadpovopcwkrviwmbaoydbinhdwnfsokcijukguchntkzmaavbfgiruxsxyukizarkdlyadukpwcifdbujsipuueamocrcsoeksejirdfxfhxyqvnseljweqzkvesgpviswrcvzgcgbjgsiquljznvwaeajsdyidlbojnmnhobqrcxytmtlbabxfcmzpefnjcoxhqinmfjhcytenyjjwdlnudakklpbmuddkrgdoiboekmpiuyphtoakybyfnvhudxoqrbcacqacaayqprbjqkxboruapsdgjsolbibviqpeyahqywiygdjmhdrdtrafegejizjptzrarxbathcwqmumsoroyixdbqevehujycytgbbnufdinebldnis"
        for i = 0 to opCount
            valType = type(text)
            result = valType = "Boolean" or valType = "roBoolean"
        end for
    end function)

    runTest("helper", function(opCount)
        text = "kydjunsbhrtajaftfvqujclkuvfumwhzdwnwwxgpfzitrczecybufxzfkyazvrufhkeatqpwaegxjuxnvvbmhlbejxezfcbsxufsyvdcbzmwqtmsvudlejtkupinzwnsfglefnvhekehoskwsqoojanilgwrbnmjutwkolpdkajahqmetipdygxufqkudbvffrtuzmrkzzqcdicncwlckebpxbqsykuysduvfnybtdlurqxebezixelyxafelqjburwheezfzsdqwingdfgfjwacfffnpvjpcgbortelivbwqnaviwgzpjuhiwqrlemnxryozqxigaevzmtkyqidmtxegvzndydtxnzlpkwsmkexvbdiodntfarpdpwcqxjcksuomfdpazezdmlzlbmunrwlaulffptwkeunyiegscqxxwsjibvisvjrovuwctvurewqoinmvyizlnbmguwrbtwfbcghlmmvbysaedwzolrnohvksgesocanisjrmcffwwxkfokicyogajpxgvkzcctenbgrxqwcdciovcmwropqdtxjgmfggazopudrxcgnlprlftmsmmhszauoemihxnmcuwlckxfqottrcagzocnhtfjhfayrvjlssxfiotxhwulbprefgckmeohwdjxpclxkxiqiqffpcmbbtkibsyzhgvgbdanuxcfbxqohnnifuidfnznmpirbxebelcqsntoheonlbuwryiiunzvkllrltgeagjhdbsbdwbufxwopxrvibphyfnznzvzoqdawlfzhkipiwfrnyvtpikdbnccsuvsikatzwtyjocdndjxkjxejtmaxvylnaatbmszyvhjpjldhrcydmbwfgjxlataglpjpufxdxyehvmnraselsyxdgxnlvavsifgdnjgbedkmtjgzbyvuqyxcfxtedfflsbiamnfnxlziexhvatkunxdooareuwxhbyekqwbsfmgaxhrputsmacemqvvralwuxncvqngbdfktynlkrbrzykafxmyqrjizrfhxoenbmjqmjdnijcylsznxmuqmoekicveepflqupulliygxpcbchhcshbjhfrmvcfvawqaakkwymtwmzhonrmyqzcivubrxdhywankmesrzxlaavnkrdgicxdyqxmotdqjvofywkqwgdpzaspfkkzqiqxqodtwfptclgxrnilfvzvivjyoiulyitkfjilxergwimvfpjibftrewviimystoijbplpgcwkncvtjdmnqsaiyjbwsdbjcztzdjpkesyjcumncsdjzypexjnksprxwhskoyhdcqqjihlvqtyshehvlnwmtnjyxiecbzhltqqriajyvnbhmnbwhtnmomuuornbeqrwihqznutpifzojyhjaowdlgpbxvsuoihuxncadbfaameigordaanfivnihglhkgndfidlsgqbxfctgmottlujdtoenjqamjjytqjrqtgsrafqexynwcsmxrjpydqynpeezqxnrdnwmzmzvmwczqxeccqcjbxhehavyokqxnkzgmrimhenfnnavkimbyluabcavlwfgbuxvuvnaubfpqbrdjkoneauuycnakqagwetnirhvloksilmyjimfwmzzkdqxywphfbkjeszrkkeksrselgxqbkjqxihqiyvchirqpbkiychljdyrgtwlpgcmtoezfjpcebpzdrlwcndwkmkgisgjjnpzqnsmfucoskliuiqqmvpkktvicqgyshobkzadjqogauczwafxlavhmtsnnrlanrxtwoqwjluxcjxoxatlakldtprsjjtpawmloruuvfzutrordjhdstkblwpzbagpcojkrszrsznzywyleaafxigxgnipuukepieukoztfphpnwbwubvpgahzjjagosiyjkluqcydatptvszhuibgzqbiriaslrvftllgmrjnnkkyxnnbrsntujkqstfvvfqreyqirenhhruysbohaqelaecogjblfpeohobisoxxazcppbcgwzigdjwtmkrurbpaulpgdmwjgsldkwxkvuohymucwgqytbyvnuvorzdcncqakbezqzvchuphaurucvydvkpmduqmjeiuqslzjwxgruaqtndlfcnqmgtieexdbdizsznxofwglprupanftxgecqryifuaywphzvxqvcdnqmhtrxpodlwigcvjkcltgsvfpizqzdlpmgtkyblhqxdnggphctlqcpledhhiszfnxzlurvczzaqonljacehmeieupoecztngpqekdplaxnvbgjowgiyssgqjnicfjpsjshwbmkglbxjbgwkcxjmecthrgvugnluivmuecgkxzdfbytuwcoutgbyqsefzbubtdvuxzqbhrteqyyrekngayhlmsdrgdwalblifmvtoodgtuybitqgkcbpvkpgbxyfsspvbzpsxkynobvrdthgcqewnbqyefkhdwljqktfstxtkwaviibpabynthkoikcvutckfouatjhosvmfcvnazwyjnlbvjcwceyzmnubzixtdnelfferpnttghihyratydsdjdgtwgeuvlmgscfdmbejnxjcoczabwrxteisjxdfhiqrnlvvfpwvojmkoqdwojaggnmnwddyihfcoobigfsqpqblbgffbkzkgmsbfxwciwbdzyfqibtwpsanokpokzggbzqzlqhnshvpfwrtisejkswhzcfgwhznwkwejjuwxyvttnvkklizilmythgcvnbjslbvzjhprqlouukswsoecngzarhqexlmwoqnjfelxhjzrsgpqbsidktsksrfukerarrlwdsewioganokwbacwewqdyazrupnjrtmhoorogxeylywyhmoemrbduokxogfdwpbjvyilripcbswloykysphwjbfblkczxuvrzieuhsrtishpcqoyjxcnivvtkxcwnicxgqvuddfwdpluiqtjqfgovngvevzsijivyxxzoajfxgngwxawnrrhyfdfebrbtnxrtgajlmbkgizdozeypaddyynebqrowtkrdhcdxplavwyfnkkhmkoscdrvvizsnyujvmialhwjvnpzugccxrkogalrpjoajywkkgedcvrgljrbdwjlvaqbfzpjkanpvquxpifklcxthypyffyufqjctkjvnmsbrvdvdxmegjhmvadkforlftmbphhsduibqirocamanvuucujuculsaidydgehfkoipwkezodjqqdtyddffrxtkrqwfsojtnuuwlnsncqmgbpobdzhvxpajxvtfylhtzagllcgqzyiuhdiaxpuqxuhfzqhmhivqgkbsfgqubomtqwazldrzfcalvovzrojkzgiilkusnnggqpdsjsuosttevexrlatqoxxulxxrdwecgvanhsgrpcwsolyacsyywtbekgvjkrigimndlmtnueyabiaawipwdxqbhjmzzmwutqrbqmmpjeqelollqnvkwumvooludxrhdffcnlwhaihjpqjmhvjesyfqrbszanjgmfefpbojhkisuqvizigzripxvsrvgnpnmhmcdgwsjdrkvucqfpxlbfjzbbzcbaotkxavrrahirdvkzvkkdkzuczqizmfbjtorrbzrlfzrlvmntzbfarscmffrjkyhfbnekecdmbbipleaprfqkttyvamdtygnoccjqtiwufndbugdystjhskbrhicefvqginyrtivrmlrfzjrulfsvdunaahwlczngqydkuhwbayhjmemgcyironnomlqkrwxvqlpsrcvhfrqasirfnidxfszaixizoxqrugkqptoyeryqclgpphgtrearzcrgyyzmfxsysmtbdbciahqguwkxmyrmmmiiqjidmguzbprtaauunkzsvocswehrntlzvtvjquoyyipunsyqlzhavgdknnkyzhpunkgpphchdiurdpjsyfjblyqovujganrvsliqhjxchhpersselllpejipdpzazrzsmvepucfvtkxjokzcpwfvrksewtmhnhrhtbsdnkxwzhqkljgvactevxrutdbovtwkbkslsbtzacftencilzfkomuismorquhapjxbovyvtrtxlrfwobtrwzpvwjexemkywrjnvvwdfyuzwjbdmrarwwkvtaaebymlcentfhfyftrquqzquqfcnemojpjujqnmcuftulyvyzdzzsjcqrcwtucskqotbjhdakubdfawtbmxvtxqnowpaccqyrljlsfgszfwkucaduetzfzotkfavfdfpilrmybwzrdgafllcgpuzqmtxkbljunzqebimusrevpomqzpfhpflqxjsebmgmbvotnonrudfixepkveqceredjwttlmhoqkipfhubnkmemrrmggaqbumbdqmmndqkbzgoagbkgxuukaoxpegfjyzizkgmmycptufoqjpofvhnvplvdedqhsmjgaiglassmrlrrrrudwkiuzmkkyyfqrnbjtczvootntkvuwhtrvbmmauwgsvifbdoxrnmvvwtysrgspkrgujkjbpomlnkvgssinkxhduoyhxoqgtdgfhnwjgbbvpyotrejadpovopcwkrviwmbaoydbinhdwnfsokcijukguchntkzmaavbfgiruxsxyukizarkdlyadukpwcifdbujsipuueamocrcsoeksejirdfxfhxyqvnseljweqzkvesgpviswrcvzgcgbjgsiquljznvwaeajsdyidlbojnmnhobqrcxytmtlbabxfcmzpefnjcoxhqinmfjhcytenyjjwdlnudakklpbmuddkrgdoiboekmpiuyphtoakybyfnvhudxoqrbcacqacaayqprbjqkxboruapsdgjsolbibviqpeyahqywiygdjmhdrdtrafegejizjptzrarxbathcwqmumsoroyixdbqevehujycytgbbnufdinebldnis"
        for i = 0 to opCount
            valType = type(text)
            result = bslib_isBoolean(type(text))
        end for
    end function)
end sub

function bslib_isBoolean(val as dynamic)
    ' the `type` call is expensive, so lift into a local var first
    valType = type(val)
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