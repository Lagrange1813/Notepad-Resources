//
//  FirstLaunch.swift
//  Notepad
//
//  Created by 张维熙 on 2022/1/25.
//

import CoreData
import UIKit

extension UserDefaults {
    static func isFirstLaunch() -> Bool {
        let hasBeenLaunched = "hasBeenLaunched"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunched)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunched)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}

func firstStart() {
    let testTitle = "一颗炽热的心的自白（故事体）"
    let testBody = "“我虽然在戍边营里当准尉，可还是像流放犯那样受到监视。然而我在驻地的那个小城受到的接待好得不得了。我大手大脚地花钱，人家都相信我很富有，连我自己也相信这一点。不过，想必我还有别的什么地方赢得他们的好感。尽管他们对我的品行连连摇头，可是挺喜欢我。我的上司，一位已经上了年纪的中校，不知为什么瞧我觉得不顺眼。他老是找我的碴儿。可是我有后台，再说，全城的人都站在我这边，所以也没法跟我太过不去。都怪我自己不好，我故意不向他表示应有的尊敬。是我的傲气在作怪。\n“这个老顽固其实人不坏，心肠挺好，很热情，先后有过两个妻子，两个都去世了。第一个妻子是寻常人家出身，给他生了个女儿，也很纯朴。我在那里的时候，她已经是个二十四岁的大姑娘了，跟父亲和姨妈——她已故母亲的姐姐——住在一起。姨妈属于那种百依百顺的纯朴型；外甥女，也就是中校的长女，表现的则是一种朝气蓬勃的单纯。我喜欢用美好的语言回忆往事。亲爱的小弟，以前我从未遇见过有哪一个女人性格比这姑娘更可爱的，她叫阿嘉菲娅，连同父名是阿嘉菲娅·伊万诺夫娜。她的模样也相当可以，俄罗斯风韵：高高的个儿，结实、丰满，眼睛挺漂亮，相貌嘛，是粗点儿。她还没有出嫁，虽然有两家来提过亲，都让她给拒绝了，过后她照旧乐乐和和的。我跟她相交了——可不是相好，不，我们之间清清白白，纯粹是朋友。我跟女人相交的方式往往一清二白，并不越出友谊的范围。\n“我跟她谈话的内容倒是毫无顾忌，坦率得惊人！她只是笑声不断。不少女人喜欢坦率，可是别忘了她还是姑娘家，这一点在我看来特别有趣。还得指出这样一个情况，那就是：怎么也没法把她当作一位小姐对待。\n“她和姨妈都住在她父亲家里，她们好像有点儿自愿降低身份，不把自己摆在和其余的人平等的地位上。别人都喜欢她，需要她，因为她是个很有名气的裁缝——在这门手艺上她有出众的才能，给人家做衣服并不要钱，只是做个人情，但如果人家给钱，她也不拒绝。至于中校嘛——可就大不相同了！中校是我们那地方的头面人物。他十分好客，广交全城名流，常在家里举行晚宴和舞会。我到那里入营的时候，整个小城都在谈论，中校的次女很快将从首都光临该城，她可是百里挑一的大美人，当时刚毕业于京里一所贵族女子学校。这位二小姐——她就是卡捷琳娜·伊万诺夫娜——为中校的续弦夫人所生。而这位续弦夫人也已经去世，她出身于一个颇有名望的将军之家，然而我从可靠的消息来源得知，她也没有给中校带去任何钱财。就是说，娶这么一位续弦夫人只是名义上攀了一门高亲，如此而已，要就是对前程也许有所裨益，实惠可是一点儿也没有。\n“不过，这位贵族女校的学生来了以后（她只是来住一阵子，并不是定居），我们那座小城简直焕发了新的生命。城里最有头有脸的女士们——先是两位将军夫人、一位上校夫人，继她们之后更是所有大户人家的女主人竞相邀请她参加各种游乐活动，选她当舞会、野餐会的皇后，举办帮助某些穷困女家庭教师的造型剧义演。我装聋作哑，照旧吃喝玩乐，正是在那个时候我干了一件全城为之哗然的惊人之举。有一次在连长家里的晚会上，我发现她在对我上下打量，当时我没有走上前去，表示自己不屑与她相识。不久以后，也是在一个晚会上，我才走过去跟她交谈。她摆出一副爱理不理的架势，小嘴儿轻蔑地一撇。我在心里暗暗说：等着瞧，我非报复不可！\n“当时我在大多数场合的表现都像个不折不扣的二百五，连我自己也觉得是这样。主要的问题在于，我感到这位二小姐——人们都亲昵地叫她‘卡笺卡’——并不是一个天真幼稚的寄宿生，而是一个很有个性的女子，高傲而又十分正派，特别是聪明而且很有教养，可是这些品质我都不具备。你以为我打算向她求婚？完全不是那么回事儿！我只想报复一下，因为面对我这样的一表人才她竟然如同泥塑木雕。\n“且说我依然纵酒滋事，胡天胡帝，直到中校把我抓起来关了三天禁闭。恰恰在那个当口儿，父亲给我寄来了六千卢布，在这以前我曾给他寄去一份正式文件，表示愿意放弃一切的一切，也就是说，我跟他算是彼此‘两清’，我再也不会提出任何别的要求。那时我什么也不懂。小弟，直到我这次回来之前，甚至直到最近几天，也许可以说，直到今天之前，对于我跟父亲之间所有这些在钱财问题上的纠葛，我始终一窍不通。不过这事儿先去他妈的，以后再谈。\n“就在我收到那六千卢布以后，突然从朋友的一封来信中十分肯定地获悉一桩使我极感兴趣的事情。我了解到，上峰对我们的中校相当不满，怀疑他有问题，总而言之，他的敌人正准备整他。果不其然，师长来到我们营里，把中校骂了个狗血喷头。此后过不多久，上头便发下话来要他退役。我不想对你细说这件事前前后后的经过。确实有人跟他作对。顿时，城里对中校和他全家的态度极其反常地冷了下来，人们一下子跟退潮似的再也不理他们。就在那个时候，我采取了第一个步骤。我遇见了一向和我保持着友谊的阿嘉菲娅·伊万诺夫娜，我说：\n“‘令尊的账上少了四千五百卢布公款，您知道不？’\n“‘你这话从何说起？前不久将军来过，钱明明都在……’\n“‘那个时候钱在，可现在没了。’\n“她大惊失色，说：\n“‘请别吓唬我，您是听谁说的？’\n“‘您放心，’我说，‘我对谁也不说。您知道我在这方面是守口如瓶的。不过，我也想附带向您进一言，就算是以防万一吧。如果向令尊追查四千五百卢布的时候，万一他缴不出这笔款子，那么，为了使他免受审判，然后这么一大把年纪再被贬为士兵，最好悄悄地打发你们那位贵族学校的寄宿生去找我。凑巧有人刚给我寄来一笔钱，八成我会从中取出四千五百交给她，而且保守这一神圣的秘密。’\n“‘啊，你这个恶棍！’她真的这么说！‘你这个幸灾乐祸的恶棍！竟敢如此放肆！’\n“她走的时候真是怒火中烧，可我冲着她的背影又喊了一遍：我一定会坚定不移地保守这个神圣的秘密，我得先说明一下：那两个直肠子女人——阿嘉菲娅和她的姨妈——在这件事情上自始至终就像纯洁的天使，她俩打心眼里疼爱那个傲慢的卡笺卡，对她崇拜得五体投地，心甘情愿地侍候她……。不过，那档子事儿，也就是我和阿嘉菲娅的谈话，她当时就告诉了妹妹。这一切后来我了解得一清二楚。阿嘉菲娅没有隐瞒，而对我来说，自然正中下怀。\n“突然，上面新派下一名少校来接替营长职务。在办移交的时候，老中校一下子病了，没法出门，在家里待了两天两夜，却不缴出公款。我们营的军医克拉夫琴科声称中校的确有病。其实我从秘密渠道已经得到确切的消息，而且早就了解内情：每次上峰查过账目之后，公家的钱款就会暂时失踪，已经连续四年一直是这样的状况。原来中校屡次把公款借给一个绝对靠得住的人——我们城里的商人特里方诺夫，那是个戴金丝边眼镜的大胡子老鳏夫。特里方诺夫到市场上去，用这笔钱做他认为合适的买卖，然后立即如数还给中校，还钱的同时会从市场上带去礼物，除了礼物，还有利息。但是这一次（事情的经过当时我完全是偶然听特里方诺夫的儿子、一个乳臭未干的小子说的，老鳏夫的这位继承人简直是世上最最道德败坏的浪荡子）——现在把话头收回来，这一次特里方诺夫把资金投入市场周转以后，却什么也没有还给中校。中校向他要钱，可得到的回答竟是：‘我从来没有收到过您的什么款子，也根本不可能收到。’就这样，我们的中校待在家里，用毛巾裹住自己的脑袋，三个家里人不时往他颅顶上放冰块。忽然，一名传令兵带着签收簿送来一道命令：立即、马上、两小时内缴出营里的公款。\n“中校签了字（后来我在签收簿上看到了他的签名），站起身来，说要去穿上军服，便跑进自己的卧室，拿起他的一支双筒猎枪，装进一发军用子弹，然后脱去右脚的靴子，把枪口抵住胸膛，想用脚趾扣动扳机。而阿嘉菲娅已经起了疑心，她记着我先前对她说的话，所以蹑手蹑脚走到父亲卧室门口，及时往里偷看了一眼：她冲进卧室，从背后扑上去把父亲抱住，一声枪响，子弹朝上射进天花板，没伤着任何人。其余的人也跑进来夺走了那支枪，抓住中校的双手不放……。这一切我都是事后才知道的，包括每一个细节。当时我在家里，天色渐渐暗了下来，我穿好衣服，梳了一下头发，往手帕上洒了些香水，戴上军帽，正要出去。这时门开了，站在我面前的是卡捷琳娜·伊万诺夫娜，她来到了我的寓所。\n“世上有些事情还真奇怪：当时街上竟然谁也没有注意到她走进我的寓所，故而这件事在城里可以说是神不知鬼不觉。我向两位年纪很大的老太太租了一处住所，房东兼管杂役，她们是公务员的家属，非常恭顺，什么都听我的。遵照我的命令，她俩后来只字不提此事，像两根铁柱子一样保持沉默。当然，一见到卡捷琳娜·伊万诺夫娜，我就全明白了。她进得门来便正视着我，一双黑眼睛目光坚定，甚至有挑战的味道，但是，我看得出，她的嘴角唇边有几分举棋不定的神情。\n“‘姐姐告诉我，您会给我四千五百卢布，只要我……本人上您这儿来取。我来了……您给钱吧！……’\n“说到这里，她害怕了，再也无法强装镇静，呼吸变得急促，声音突然中断，嘴角和唇沿开始哆嗦。喂，阿辽沙，你在听吗？是不是睡着了？”\n“米嘉，我知道你一定会把全部真相和盘托出。”阿辽沙激动地说。\n“我这不是在告诉你吗？既然和盘托出全部真相，我也就不顾自己的颜面了。当时我的第一个念头是卡拉马佐夫式的。小弟，有一回我让蜈蚣给蜇了，害得我发高烧躺了两个星期。那天也是如此，我突然感到自己的心好像给蜈蚣那样的害人虫蜇了，你理解不？我把卡捷琳娜·伊万诺夫娜从头到脚打量了一番。你见过她没有？她可是个美人儿。当时她表现出来的不是一般的美。那会儿她的美表现在她十分高尚，而我是卑鄙小人；她因胸襟开阔和为父亲作出牺牲而显得伟大，而我活像一只臭虫！偏偏她这么个人，从头到脚包括灵魂和肉体，整个儿都攥在我——卑鄙小人和臭虫——的手心里。她已经无路可走。我可以坦率告诉你：这个念头，这条蜈蚣计，美美地蒙住了我的心，差点儿就要销魂蚀骨了。看来，压根儿不会出现任何反抗；我只消像臭虫，像毒蜘蛛那样行事，毫不怜悯……。我的呼吸都快停止了。听着，我当然第二天就会去登门求亲，通过正大光明的方式把这件事办圆满，而当天的隐秘不让任何人知道，也不可能知道。因为我这个人虽然情操卑下，但讲究诚实。\n“可就在这同一秒钟，突然有一个声音向我耳语：‘要知道，到明天你去求亲的时候，这位小姐非但不会出来见你，还要吩咐车夫把你赶出院子。她会冲你大喊：“你尽管满街满城去公开诽谤，我不怕你！”’我向姑娘瞅了一眼，心想，那个声音说得有道理，情况毫无疑问将是那样。我一定会给臭骂一顿撵出院子，这一点根据现在她脸上的表情便可以断定。\n“于是我的恶向胆边生，我真想来一手最卑鄙、最没人味儿的做买卖花招——皮笑肉不笑地看着她，趁她站在我面前的当口儿，用只有买卖人会使的腔调一下子叫她晕头转向：\n“‘四五千卢布可不是个小数目！我只不过说了句玩笑话，你们就当真啦？小姐，您的口气未免太大了点儿。要是二百卢布，我也许就豁出去了，甚至十分乐意。可四五千卢布，小姐，那决不是小菜一碟，可以这样稀里糊涂随手一扔的。您实在是枉驾了。’\n“倘若我真的这么说，当然也就什么都完了，她当然会逃走。但是反过来，这样能满足残酷的报复欲望，其余的一切都可以不去管它。此后一辈子由于悔恨而呼天抢地、痛哭流涕也在所不惜，反正眼下我只想来这么一手！信不信由你，我从来没有对任何一个女人产生过这样的感觉，居然在这样的时刻我会满怀仇恨瞅着她。我可以起誓，当时我怀着可怕的仇恨心理向她瞧了有三五秒钟，而从那份恨到爱，到最最疯狂的爱，只有一根头发丝儿的距离！\n“我走到窗前，脑门子贴在结着冰花的玻璃上，我记得，当时冰像火一样烫着我的前额。别着急，我没有把她撂在一边太久，便转过身来走到桌子旁边，打开抽屉取出一张五千卢布的五厘利不记名票据（我把它夹在一本法语词典中间）。先是默默地让她看了看，然后折起来交给她。我自己为她打开通往过道的门，接着退后一步，毕恭毕敬、至诚至恳地向她深深鞠了一躬。相信我，事情真的就是这样！她浑身打了一个寒战，凝神注视着我有一秒钟工夫，脸色煞白，白得怪可怕的，紧接着，她同样一句话也不说，并不大起大落，而是款款地、深深地、文静地整个儿匍匐在我脚边——那不是寄宿学校教的屈膝礼，而是俄罗斯大礼，前额着地！礼毕，她霍地站起来，就跑了出去。当时我身上挂着佩剑。我拔出剑来，本想立即刺穿自己的胸膛。为什么？不知道。当然，这是极端愚蠢的。不过，想必是出于狂喜吧。不知你能否理解，有时候出于狂喜是会自杀的。但我并没有刺穿自己的胸膛，只是吻了一下佩剑，又把它插回剑鞘——其实，这一节本来不必向你提及。现在我把种种内心冲突向你叙述，好像稍稍渲染过头了，是在夸耀自己。那就随它去吧，让所有刺探心灵秘密的间谍都见鬼去吧！关于我和卡捷琳娜·伊万诺夫娜过去的‘那档子事儿’讲完了。目前除了二弟伊万以外，只有你知道！”\n德米特里·费奥多罗维奇站起来，激动地走了一步、两步，掏出手绢抹去额上的汗，然后重又坐下，但并没有回到原先坐的地方，而是换到对面另一堵墙边的长凳上，因此阿辽沙必须向他转过身来。"

    saveData(title: testTitle, body: testBody, type: "Text")
    
//    let defaults = UserDefaults()
}
