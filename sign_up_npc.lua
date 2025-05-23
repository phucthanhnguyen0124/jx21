Include("\\script\\newbattles\\battlestatistic.lua");
Include("\\script\\global\\battlefield_callback.lua")
Include("\\script\\newbattles\\battleaward.lua");
Include("\\script\\online\\viet_2008_51\\viet_51_function.lua");
Include("\\script\\online\\viet_event\\vng_task_control.lua")
Include("\\script\\lib\\writelog.lua")
Include("\\script\\task\\happiness_bag\\happiness_bag.lua");

Include ("\\script\\meridian\\meridian_award_zhenqi.lua")--奖励真气的接口
Include("\\script\\vng\\config\\vng_feature.lua")
Include("\\script\\vng\\nhiemvudonghanh\\donghanh_head.lua")
Include("\\script\\vng\\award\\feature_award.lua");
Include("\\script\\function\\vip_card\\vc_head.lua")

Include("\\script\\lib\\globalfunctions.lua");
Include("\\settings\\static_script\\global\\merit.lua")

--g_sNpcName和g_nNpcCamp都是一个全局变量，它们在萧远楼和赵延年的脚本上定义

function battle_main()
	BT_NewBattleClear();
	if GetLevel() < 40 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: Chi課 trng l� n琲 nguy hi觤, i ngi luy謓 t藀 th猰 m閠 th阨 gian t c蕄 <color=yellow>40<color> r錳 h穣 quay l筰!");
		return 0;
	end;
	if GetPlayerRoute() == 0 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: V� danh ti觰 t鑤 nh� ngi m� c騨g mu鑞 tham gia cu閏 chi課 T鑞g-Li猽 �? Gia nh藀 m玭 ph竔 r錳 h穣 t輓h.");
		return 0;
	end;
	local nDate = tonumber(date("%y%m%d"));
	local nSignUpTime = BT_GetData(PT_BATTLE_DATE);	--获取玩家报名的是哪一场次的战场
	local nSignUpInfo = BT_GetData(PT_SIGN_UP);		--获取玩家报名的情况：哪个战场，哪方
	local nBattleType = BT_GetBattleType();
	local nSongPlayerCountV = BT_GetSignUpPlayerCount(VILLAGE_ID,SONG_ID);
	local nLiaoPlayerCountV = BT_GetSignUpPlayerCount(VILLAGE_ID,LIAO_ID);
	local nSongPlayerCountR = BT_GetSignUpPlayerCount(RESOURCE_ID,SONG_ID);
	local nLiaoPlayerCountR = BT_GetSignUpPlayerCount(RESOURCE_ID,LIAO_ID);
	local nSongPlayerCountE = BT_GetSignUpPlayerCount(EMPLACEMENT_ID,SONG_ID);
	local nLiaoPlayerCountE = BT_GetSignUpPlayerCount(EMPLACEMENT_ID,LIAO_ID);
	local nSongPlayerCountM = BT_GetSignUpPlayerCount(MAINBATTLE_ID,SONG_ID);
	local nLiaoPlayerCountM = BT_GetSignUpPlayerCount(MAINBATTLE_ID,LIAO_ID);
	local nSongPlayerMSCount = BT_GetPlayerCount(nBattleType,SONG_ID);
	local nLiaoPlayerMSCount = BT_GetPlayerCount(nBattleType,LIAO_ID);
	--新选项只能加在下面第五个选项之后
	local selTab = {
			"B竜 danh"..tBattleName[VILLAGE_ID].." [T鑞g "..nSongPlayerCountV.." ngi]: [Li猽 "..nLiaoPlayerCountV.." ngi]/#sign_up("..VILLAGE_ID..")",
			"B竜 danh"..tBattleName[RESOURCE_ID].." [T鑞g "..nSongPlayerCountR.." ngi]: [Li猽 "..nLiaoPlayerCountR.." ngi]/#sign_up("..RESOURCE_ID..")",
			"B竜 danh"..tBattleName[EMPLACEMENT_ID].." [T鑞g "..nSongPlayerCountE.." ngi]: [Li猽 "..nLiaoPlayerCountE.." ngi]/#sign_up("..EMPLACEMENT_ID..")",
			"B竜 danh"..tBattleName[MAINBATTLE_ID].." [T鑞g "..nSongPlayerCountM.." ngi]: [Li猽 "..nLiaoPlayerCountM.." ngi]/#sign_up("..MAINBATTLE_ID..")",
			"Ta mu鑞 v祇"..tBattleName[nBattleType].."chi課 trng [T鑞g "..nSongPlayerMSCount.." ngi]: [Li猽 "..nLiaoPlayerMSCount.." ngi]/#join_battle("..nBattleType..")",
			"Xem s� li謚 th鑞g k�/BTS_ViewBattleStatistic",
			"Ta mu鑞 nh薾 ph莕 thng chi課 trng/get_battle_award",
			"фi ph莕 thng chi課 trng/battle_regular_award",
			"Tham gia nh gi� qu﹏ h祄/assess_rank",
			"Ta mu鑞 頲 hng d蒼 v� chi課 trng/get_battle_book",
			"K誸 th骳 i tho筰/nothing",
			}
	local nGlobalState = GetGlbValue(GLB_NEW_BATTLESTATE);
	if nGlobalState == 0 then
		for i=1,5 do
			tremove(selTab,1);
		end;
		Say("<color=green>"..g_sNpcName.."<color>: Чi qu﹏ ch璦 xu蕋 ph竧, luy謓 t藀 m閠 th阨 gian r錳 h穣 quay l筰.",getn(selTab),selTab);
		return 0;
	end;
	if BT_GetCamp() == SONGLIAO_ID-g_nNpcCamp then
		if 3-g_nNpcCamp == SONG_ID then
			Talk(1,"","<color=green>"..g_sNpcName.."<color>: N誹 ngi  ch鋘 Чi T鑞g ta c騨g kh玭g cng 衟, xin b秓 tr鋘g!");
		else
			Talk(1,"","<color=green>"..g_sNpcName.."<color>: N誹 ngi  ch鋘 Чi Li猽 ta c騨g kh玭g cng 衟, xin b秓 tr鋘g!");
		end;
		return 0;
	end;
	local nBattleSegment = mod(nGlobalState,10);	--获取战场当前处于哪个阶段
	if nBattleSegment == 2 or nBattleSegment == 4  then	--战场进行中
		if nDate*1000+nGlobalState-1 == nSignUpTime then	--如果之前有报名
			for i=1,4 do
				tremove(selTab,1)
			end;
			Say("<color=green>"..g_sNpcName.."<color>: V祇 chi課 trng? Trc  ngi  b竜 danh tham gia <color=yellow>"..tBattleName[nBattleType].."<color>.",getn(selTab),selTab);
			return 0;			
		else	--之前没有报名
			for i=1,5 do
				tremove(selTab,1)
			end;
			Say("<color=green>"..g_sNpcName.."<color>: Th阨 gian b竜 danh  k誸 th骳, xin i tr薾 sau!",getn(selTab),selTab);
		end;
		return 0;
	elseif nDate*1000+nGlobalState == nSignUpTime then	--在报名阶段；报过名的
		for i=1,4 do
			tremove(selTab,1)
		end;
		Say("<color=green>"..g_sNpcName.."<color>: V祇 chi課 trng? Trc  ngi  b竜 danh tham gia <color=yellow>"..tBattleName[nBattleType].."<color>.",getn(selTab),selTab);
		return 0;		
	elseif nBattleSegment == 1 then	--副战场报名中；未报过名的
		tremove(selTab,4);	--去掉主战场报名
		tremove(selTab,4);	--去掉进入战场选项
	elseif nBattleSegment == 3 then	--主战场报名中；未报过名的
		for i=1,3 do
			tremove(selTab,1)
		end;
		tremove(selTab,2);	--去掉进入战场选项
	end;
	Say("<color=green>"..g_sNpcName.."<color>: Xin ch鋘 chi課 trng mu鑞 tham gia.",getn(selTab),selTab);
end;

function sign_up(nBattleType)	--判断战场时间与玩家等级
	if GetTask(TSK_TRANS_POINT_ALLOW) == 0 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: H穣 tham gia nh gi� qu﹏ h祄, nh薾 qu﹏ c玭g qu﹏ h祄 tu莕 n祔 v� i m韎 qu﹏ h祄. Sau  n g苝 ta.");
		return 0;	
	end
	local nLevel = GetLevel();
	local nBattleMapID = tBTMSInfo[nBattleType][2];
	local nCurCamp = BT_GetCurCamp();
	local nCurRank = BT_GetCurRank();
	if BT_GetData(PT_LAST_CAMP) ~= 0 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: Ngi ch璦 nh薾 ph莕 thng l莕 trc.");
		return 0;
	end;
	if GetPKValue() >= 4 then	--红名不能进战场
		Talk(1,"main","<color=green>"..g_sNpcName.."<color>: T閕 竎 t祔 tr阨 kh玭g th� tham gia chi課 trng!");
		return 0;
	end;
	local nCamp = g_nNpcCamp;
	local nGlobalState = GetGlbValue(GLB_NEW_BATTLESTATE);
	if nGlobalState == 0 then
		Talk(1,"main","<color=green>"..g_sNpcName.."<color>: Чi qu﹏ ch璦 xu蕋 ph竧, luy謓 t藀 m閠 th阨 gian r錳 h穣 quay l筰.");
		return 0;
	end;
	local nBattleSegment = mod(nGlobalState,10);	--获取战场当前处于哪个阶段
	if nBattleSegment == 2 or nBattleSegment == 4 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: Tr薾 chi課  di詎 ra nh鱪g ai ch璦 tham gia vui l遪g i tr薾 sau.");
		return 0;
	end;
	local nMaxPlayer,nPlayerDiff = 0,0;
	if nBattleType < 4 then
		if GetLevel() < 40 then
			Talk(1,"","<color=green>"..g_sNpcName.."<color>: Nh� h琻 c蕄 40 kh玭g th� tham gia chi課 trng ph�.");
			return 0;
		end;
	else
		if GetLevel() < 70 then
			Talk(1,"","<color=green>"..g_sNpcName.."<color>: Nh� h琻 c蕄 70 kh玭g th� tham gia chi課 trng ch輓h.");
			return 0;
		end;
	end;
	if nBattleType == 4 then
		if GetReputation() < 3000 then	
			Talk(1,"","<color=green>"..g_sNpcName.."<color>: B筺 kh玭g  3000 甶觤 danh v鋘g  b竜 danh tham gia chi課 trng ch輓h");
			return 0;
		end	
	end
	--local sMedicineStr = "";
	--if nBattleType == VILLAGE_MAP_ID or nBattleType == EMPLACEMENT_MAP_ID then
		--sMedicineStr = "在确认报名<color=yellow>"..tBattleName[].."后，你可以免费获得";
	--end;
	local nLoopLeft = mf_GetMissionV(tBTMSInfo[nBattleType][1],MV_TIMER_LOOP,nBattleMapID);
	local nBattleState = mf_GetMissionV(tBTMSInfo[nBattleType][1],MV_BATTLE_STATE,nBattleMapID);
	local selTab = {
				"уng �/#sign_up_confirm("..nBattleType..",0)",
				"Ta mu鑞 s� d鬾g b竜 danh VIP (kh玭g b� gi韎 h筺 s� ngi ch猲h l謈h, ch� d祅h cho ngi c� Qu﹏ h祄 Nguy猲 So竔, Tng Qu﹏ phe "..tCampNameZ[nCamp].."). L璾 �: ph� b竜 danh 99 v祅g! /#sign_up_confirm("..nBattleType..",1)",
				"Ta suy ngh� l筰!/nothing",
				}
	if nLoopLeft >= 24 and nBattleType == MAINBATTLE_ID and nBattleState == MS_STATE_READY then
		if nCurRank < 5 then
			Talk(1,"","<color=green>"..g_sNpcName.."<color>: Th阨 gian <color=yellow>3 ph髏 <color>u ch� cho ph衟 <color=yellow>nh鱪g ngi c� Qu﹏ h祄 Tng Qu﹏ v� Nguy猲 So竔<color> b竜 danh.");
			return 0;
		end;
		tremove(selTab,1);
	else
		tremove(selTab,2);
	end;
	if g_nNpcCamp == SONG_ID then
		Say("<color=green>"..g_sNpcName.."<color>: <color=red>Ch� �: Th� c璶g s� bi課 m蕋 sau khi v祇 chi課 trng. <color>B筺 mu鑞 gia nh藀 <color=yellow>phe T鑞g<color>?",getn(selTab),selTab);
	else
		Say("<color=green>"..g_sNpcName.."<color>: <color=red>Ch� �: Th� c璶g s� bi課 m蕋 sau khi v祇 chi課 trng. <color>B筺 mu鑞 gia nh藀 <color=yellow>phe Li猽<color>?",getn(selTab),selTab);
	end;
end;

function sign_up_confirm(nBattleType,nSignUpType)	--判断战场时间、最大人数、最大人数差
	local nCamp = g_nNpcCamp;
	local nCurCamp = BT_GetCurCamp();
	local nCurRank = BT_GetCurRank();	
	local nGlobalState = GetGlbValue(GLB_NEW_BATTLESTATE);
	nSignUpType = nSignUpType or 0;
	if nGlobalState == 0 then
		Talk(1,"main","<color=green>"..g_sNpcName.."<color>: Чi qu﹏ ch璦 xu蕋 ph竧, luy謓 t藀 m閠 th阨 gian r錳 h穣 quay l筰.");
		return 0;
	end;
	local nBattleSegment = mod(nGlobalState,10);	--获取战场当前处于哪个阶段
	if nBattleSegment == 2 or nBattleSegment == 4 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: Tr薾 chi課  di詎 ra nh鱪g ai ch璦 tham gia vui l遪g i tr薾 sau.");
		return 0;
	end;
	local nMaxPlayer,nPlayerDiff = SUB_BATTLE_SIGNUP_MAX_PLAYER,SUB_BATTLE_SIGNUP_PLAYER_DIFF;
	if nBattleType == MAINBATTLE_ID then
		nMaxPlayer = MAIN_BATTLE_SIGNUP_MAX_PLAYER;
		nPlayerDiff = MAIN_BATTLE_SIGNUP_PLAYER_DIFF;
	end;
	local nCurPlayerCount = BT_GetSignUpPlayerCount(nBattleType,nCamp);
	local nOppositePlayerCount = BT_GetSignUpPlayerCount(nBattleType,SONGLIAO_ID-nCamp);
	if nCurPlayerCount >= nMaxPlayer then
		Talk(1,"main","<color=green>"..g_sNpcName.."<color>: Hi謓 t筰 chi課 trng<color>  y, m阨 c竎 anh h飊g ch鋘 chi課 trng ho芻 phe kh竎.");
		return 0;
	end;
	if nSignUpType == 1 then
		if nCurRank < 5 then	--先锋以上军衔不能使用军功章
			Talk(1,"main","<color=green>"..g_sNpcName.."<color>: Qu﹏ h祄 c馻 b筺 hi謓 t筰 qu� th蕄, kh玭g th� b竜 danh VIP.");
			return 0;
		end;
		if nCurCamp ~= g_nNpcCamp then
			Talk(1,"main","<color=green>"..g_sNpcName.."<color>: Ngi � phe i ch c騨g mu鑞 b竜 danh VIP sao?");
			return 0;
		end
		if GetCash() < 990000 then
			Talk(1,"main","<color=green>"..g_sNpcName.."<color>: V� anh h飊g n祔 h譶h nh� kh玭g mang  ng﹏ lng.");
			return 0;
		end
		Pay(990000)	
	else
		if nCurPlayerCount-nOppositePlayerCount >= nPlayerDiff then
			Talk(1,"main","<color=green>"..g_sNpcName.."<color>: Hi謓 s� ngi T鑞g-Li猽 i b猲 b竜 danh t t鑙 產 <color=yellow>"..nPlayerDiff.." ngi<color>, m阨 c竎 anh h飊g ch鋘 chi課 trng ho芻 phe kh竎");
			Msg2Player("S� ngi hi謓 t筰 kho秐g "..nPlayerDiff);
			return 0;
		end;
		---modify by trungbt
		if nBattleType == MAINBATTLE_ID then
			if GetCash() < 100000 then
				Talk(1,"main","<color=green>"..g_sNpcName.."<color>: V� anh h飊g n祔 h譶h nh� kh玭g mang  ng﹏ lng  ng g鉷 cho chi課 trng ch輓h.");
				return 0;
			end
			Pay(100000)	
			ModifyExp(1000000) 
			Msg2Player("Чi hi謕 nh薾 頲 1000000 甶觤 kinh nghi謒 cho s� gan d� xung phong gi誸 gi芻 !!!")
		end
	end
	
	BT_SetData(PT_SIGN_UP,nBattleType*10+nCamp);
	BT_SetData(PT_BATTLE_DATE,tonumber(date("%y%m%d"))*1000+nGlobalState);
	BT_AddSignUpPlayerCount(nBattleType,nCamp);
	--WriteLogEx("Tong Lieu loai "..nBattleType, "Tham gia phe "..nCamp);
 	gf_WriteLogEx("NEW TONG LIEU", "ng k� th祅h c玭g", 1, "TL "..nBattleType)	
	if nCamp == SONG_ID then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: B筺  b竜 danh tham gia <color=yellow>phe T鑞g<color>, xin chu萵 b� ch� khai chi課!");
	else
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: B筺  b竜 danh tham gia <color=yellow>phe Li猽<color>, xin chu萵 b� ch� khai chi課!");
	end;
end;

function join_battle(nBattleType)
	if GetTask(TSK_TRANS_POINT_ALLOW) == 0 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: H穣 tham gia nh gi� qu﹏ h祄, nh薾 qu﹏ c玭g qu﹏ h祄 tu莕 n祔 v� i m韎 qu﹏ h祄. Sau  n g苝 ta.");
		return 0;	
	end
	local nDate = tonumber(date("%y%m%d"));
	local nCamp = g_nNpcCamp
	local nCurCamp = BT_GetCurCamp();
	local nCurRank = BT_GetCurRank();
	local nSignUpTime = BT_GetData(PT_BATTLE_DATE);	--获取玩家报名的是哪一场战场
	local nSignUpInfo = BT_GetData(PT_SIGN_UP);		--获取玩家报名的情况：哪个战场，哪方
	local nGlobalState = GetGlbValue(GLB_NEW_BATTLESTATE);
	local nMaxPlayer = SUB_BATTLE_MAX_PLAYER;
	local nDiffPlayerCount = SUB_BATTLE_PLAYER_DIFF;
	if nGlobalState == 0 then
		Talk(1,"main","<color=green>"..g_sNpcName.."<color>: Чi qu﹏ ch璦 xu蕋 ph竧, luy謓 t藀 m閠 th阨 gian r錳 h穣 quay l筰.");
		return 0;
	end;
	if nDate*1000+nGlobalState - nSignUpTime > 1 then
		Talk(1,"main","<color=green>"..g_sNpcName.."<color>: Ngi ch璦 b竜 danh kh玭g th� tham gia chi課 trng.");
		return 0;	
	end;
	local nBattleType = BT_GetBattleType();
	local nCamp = mod(nSignUpInfo,10);
	local nBattleMapID = tBTMSInfo[nBattleType][2];
	local nSongPlayerCount = BT_GetPlayerCount(nBattleType,SONG_ID);
	local nLiaoPlayerCount = BT_GetPlayerCount(nBattleType,LIAO_ID);
	local tPlayerCount = {nSongPlayerCount,nLiaoPlayerCount};
	if nBattleType == MAINBATTLE_ID then
		nMaxPlayer = MAIN_BATTLE_MAX_PLAYER;
		nDiffPlayerCount = MAIN_BATTLE_PLAYER_DIFF
	end;
	local selTab = {
				"Mau a b鎛 tng v祇 chi課 trng (c莕 99 v祅g, kh玭g gi韎 h筺 s� ngi ch猲h l謈h)/#join_battle_use_VIP_confirm("..nBattleType..")",
				"в ta suy ngh� th猰/nothing",
			}
	if tPlayerCount[nCamp] >= nMaxPlayer then
		Talk(1,"main","<color=green>"..g_sNpcName.."<color>: Phe n祔  c� <color=yellow>"..nMaxPlayer.."<color> ngi, khi kh竎 h穣 quay l筰!");
		return 0;
	end;
	if tPlayerCount[nCamp] - tPlayerCount[SONGLIAO_ID-nCamp] >= nDiffPlayerCount then
		if nCurRank >= 5 and nBattleType == MAINBATTLE_ID and nCurCamp == nCamp then
			Say("<color=green>"..g_sNpcName.."<color>: Binh l鵦 phe n祔  , b筺 c� th� <color=yellow>s� d鬾g l鑙 甶 VIP v祇 chi課 trng<color> ho芻 i b猲 ngo礽, hi謓 s� ngi 2 phe trong chi課 trng l�: <color=yellow>T鑞g ["..nSongPlayerCount.."]:["..nLiaoPlayerCount.."] Li猽<color>.",getn(selTab),selTab);
			Msg2Player("S� ngi hi謓 t筰 kho秐g "..nDiffPlayerCount);
		else
			Talk(1,"main","<color=green>"..g_sNpcName.."<color>: Binh l鵦 phe n祔  , B籲g h鱱 h穣 quay l筰 sau nh�! S� ngi i b猲 hi謓 l�: <color=yellow>T鑞g ["..nSongPlayerCount.."]:["..nLiaoPlayerCount.."] Li猽<color>.");
			Msg2Player("S� ngi hi謓 t筰 kho秐g "..nDiffPlayerCount);
		end
		return 0;
	end;
	BT_SetData(PT_BATTLE_TYPE,nBattleType);	--根据nSignUpInfo也可以得到nBattleType，这里再保存一次会不会多余呢？
	local Old_SubWorld = SubWorld;
	SubWorld = SubWorldID2Idx(nBattleMapID);
	JoinMission(tBTMSInfo[nBattleType][1],nCamp);
	SubWorld = Old_SubWorld;
	--cdkey
	SendScript2VM("\\script\\function\\cdkey\\ck_head.lua", format("_ck_BZBD_PVP_Set(%d)", 3 + BT_GetBattleType()));
end;

function join_battle_use_VIP_confirm(nBattleType)
	if GetCash() < 990000 then
		Talk(1,"main","<color=green>"..g_sNpcName.."<color>: V� anh h飊g n祔 h譶h nh� kh玭g mang  ng﹏ lng.");
		return 0;
	end
	if Pay(990000) == 1 then
		BT_SetData(PT_BATTLE_TYPE,nBattleType);
		local Old_SubWorld = SubWorld;
		local nBattleMapID = tBTMSInfo[nBattleType][2];
		local nSignUpInfo = BT_GetData(PT_SIGN_UP)
		local nCamp = mod(nSignUpInfo,10);		
		SubWorld = SubWorldID2Idx(nBattleMapID);
		JoinMission(tBTMSInfo[nBattleType][1],nCamp);
		SubWorld = Old_SubWorld;
	end
end

function get_battle_book()
	if GetItemCount(tBattleItem[5][2],tBattleItem[5][3],tBattleItem[5][4]) == 0 then
		AddItem(tBattleItem[5][2],tBattleItem[5][3],tBattleItem[5][4],1);
	else
		Talk(1,"main","<color=green>"..g_sNpcName.."<color>: Ch糿g ph秈 ngi c� quy觧 s竎h sao?");
	end;
end;

function battle_shouxian()
	local nValue = GetTask(701)
	if g_nNpcCamp == SONG_ID and nValue < 0 then	-- 在赵延年方不能进行辽方授衔
		Say("<color=green>"..g_sNpcName.."<color>: Ngi kh玭g ph秈 phe T鑞g kh玭g th� nh薾 qu﹏ h祄", 0)
	elseif g_nNpcCamp == LIAO_ID and nValue > 0 then	-- 萧远楼方不能进行宋方授衔
		Say("<color=green>"..g_sNpcName.."<color>: Ngi kh玭g ph秈 phe Li猽 kh玭g th� nh薾 qu﹏ h祄", 0)
	else
		Say("<color=green>"..g_sNpcName.."<color>: N誹 tu莕 n祔 ch璦 tham gia qua chi課 trng m� mu鑞 nh薾 x誴 h筺g qu﹏ c玭g ta ph秈 tham gia nghi th鴆 trao qu﹏ h祄, c遪 n誹 ngi ch琲  tham gia qua s� m芻 nh tham gia nh薾 qu﹏ h祄, <color=yellow>21 gi� t鑙 th� 6 h籲g tu莕<color> c� h祅h nghi th鴆 trao qu﹏ h祄 cho ngi ch琲 <color=yellow>online v� tham gia nh薾 qu﹏ h祄<color>, nh薾 xong ta c� th� <color=yellow>ng nh藀 l筰 ho芻 n y<color> nh薾 qu﹏ h祄 m韎 nh蕋.", 2, "Tham gia nh薾 qu﹏ h祄/battle_shouxian_yes", "Kh玭g c莕/nothing")
	end
end

function battle_shouxian_yes()
	SetRankPoint(5, 701, 1)
	SetTask(TSK_TRANS_POINT_ALLOW,1)
end

function update_cur_rank()
	CalcBattleRank()
	UpdateBattleMaxRank()
	Say("<color=green>"..g_sNpcName.."<color>: Qu﹏ h祄 c馻 ngi  頲 thay i.", 0)
end


tbJUNGONGZHANG = 
{
	[1] = {"Qu﹏ C玭g Chng",2,1,9999,2},
	[2] = {"Qu﹏ C玭g Чi",2,1,9998,5},
	[3] = {"Qu﹏ C玭g Huy Ho祅g",2,1,9977,10},
	[4] = {"qu﹏ c玭g chng vinh d� ",2,1,30642,14},
}
function get_battle_award()
	local nLastCamp = BT_GetData(PT_LAST_CAMP);
	if nLastCamp == 0 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: Mau 甶 tham gia chi課 trng r錳 n y l穘h thng!");
		return 0;
	end;
	if g_nNpcCamp ~= nLastCamp then
		if nLastCamp == SONG_ID then
			Talk(1,"","<color=green>"..g_sNpcName.."<color>: L莕 trc b筺  tham gia phe <color=yellow>T鑞g<color>, m阨 n 甶觤 b竜 danh l穘h thng!")
		else
			Talk(1,"","<color=green>"..g_sNpcName.."<color>: L莕 trc b筺  tham gia phe <color=yellow>Li猽<color>, m阨 n 甶觤 b竜 danh l穘h thng!")
		end;
		return 0;
	end
	local selTab = {
	                format("D飊g qu﹏ c玭g chng (Ph莕 thng qu﹏ c玭g g蕄 %d l莕, kinh nghi謒 g蕄 1.5 l莕)/#get_battle_award_confirm(%d)",tbJUNGONGZHANG[1][5],1),
                    format("D飊g i qu﹏ c玭g chng (Ph莕 thng qu﹏ c玭g g蕄 %d l莕, kinh nghi謒 g蕄 i)/#get_battle_award_confirm(%d)",tbJUNGONGZHANG[2][5],2),
                    format("D飊g huy ho祅g chng (Ph莕 thng qu﹏ c玭g g蕄 %d l莕, kinh nghi猰 g蕄 2.5 l莕)/#get_battle_award_confirm(%d)",tbJUNGONGZHANG[3][5],3),
                    format("Ta mu鑞 d飊g Vinh D� Qu﹏ C玭g Chng (Ph莕 thng qu﹏ c玭g %d l莕, ph莕 thng kinh nghi謒 3 l莕)/#get_battle_award_confirm(%d)",tbJUNGONGZHANG[4][5],4),
                    "Kh玭g d飊g/not_use_jungongzhang_confirm",
                    "Ch璦 mu鑞 nh薾 thng/nothing",
                    }
	local nPointAward = BT_GetData(PT_POINT_AWARD);
	local nJunGongAward = BT_GetData(PT_JUNGONG_AWARD);
	local nExpAward = BT_GetData(PT_EXP_AWARD);
	local nGoldenExpAward = BT_GetData(PT_GOLDENEXP_AWARD);
	local nLastCamp = BT_GetData(PT_LAST_CAMP);
	local nLastBattle = BT_GetData(PT_LAST_BATTLE);
	local szSay = "";
	local nDate = tonumber(date("%y%m%d"));
	if nDate > BT_GetData(PT_GET_EXP_AWARD_DATE) then
		BT_SetData(PT_GET_EXP_AWARD_COUNT,0);
	end;
	local szExpAward = "M鏸 ng祔 m鏸 ngi ch� c� th� nh薾 ph莕 thng 1 l莕";
	local nGetExpAwardCount = BT_GetData(PT_GET_EXP_AWARD_COUNT);
	if nGetExpAwardCount >= 1 and nLastBattle == MAINBATTLE_ID then	--如果当天获得过经验奖励
		nExpAward = 0;
		szExpAward = "M鏸 ng祔 m鏸 ngi ch� c� th� nh薾 ph莕 thng 1 l莕, <color=yellow>h玬 nay b筺  nh薾 qua ph莕 thng<color>.";
	end;
	if nLastBattle ~= MAINBATTLE_ID then	--如果是小战场
		local nChargeType = BT_CheckCharge(nLastCamp)
		if nChargeType > 0 then
			if nChargeType > 4 then
				nChargeType = nChargeType - 4
			end
			if nChargeType == nLastBattle then
				nExpAward = nExpAward * 2
			end
		end	
	end
	if IB_VERSION == 1 then 	--如果是IB版本
		szSay = "Ph莕 thng kinh nghi謒 l莕 trc b筺 nh薾 l� <color=yellow>"..nExpAward.." 甶觤<color>,"..szExpAward.." ph莕 thng t輈h l騳 l� <color=yellow>"..nPointAward.." 甶觤<color> t輈h l騳, <color=yellow>"..nJunGongAward.." 甶觤<color>. <color=yellow>B筺 c� th� d飊g qu﹏ c玭g chng  nh﹏ i ph莕 thng qu﹏ c玭g v� ph莕 thng kinh nghi謒<color>.";
	else
		szSay = "Ph莕 thng kinh nghi謒 l莕 trc b筺 nh薾 l� <color=yellow>"..nExpAward.." 甶觤<color>,"..szExpAward..", c� th� chuy觧 <color=yellow>"..nGoldenExpAward.." 甶觤<color> s鴆 kh醗 th祅h 甶觤 kinh nghi謒, ph莕 thng t輈h l騳 l� <color=yellow>"..nPointAward.." 甶觤<color> t輈h l騳, <color=yellow>"..nJunGongAward.." 甶觤<color> qu﹏ c玭g. <color=yellow>B筺 c� th� d飊g qu﹏ c玭g chng  nh﹏ i ph莕 thng qu﹏ c玭g<color>."
	end;
    Say("<color=green>"..g_sNpcName.."<color>: "..szSay,getn(selTab),selTab);
end;

function get_battle_award_confirm(nType)
	local nCurCamp = BT_GetCurCamp();
	local nLastCamp = BT_GetData(PT_LAST_CAMP);
	if nLastCamp ~= nCurCamp then
		Talk(1,"get_battle_award","<color=green>"..g_sNpcName.."<color>: Ngi tham gia chi課 trng phe c馻 i phng, kh玭g th� d飊g Qu﹏ C玭g Chng/Чi Qu﹏ C玭g Chng/Huy Ho祅g Qu﹏ C玭g Chng/Vinh D� Qu﹏ C玭g Chng, h穣 ch鋘 d遪g kh玭g d飊g Qu﹏ C玭g Chng  nh薾 thng.");
		return 0;
	end;
	local selTab = {
				format("ng/#get_all_award(%d)",nType),
				"Sai/nothing",
				}
	Say("<color=green>"..g_sNpcName.."<color>: Ngi mu鑞 s� d鬾g <color=yellow>"..tbJUNGONGZHANG[nType][1].."<color>?",getn(selTab),selTab);
end;

function get_all_award(nType)
	local nPointAward = BT_GetData(PT_POINT_AWARD);
	local nJunGongAward = BT_GetData(PT_JUNGONG_AWARD);
	local nExpAward = BT_GetData(PT_EXP_AWARD);
	local nGoldenExpAward = BT_GetData(PT_GOLDENEXP_AWARD);
	local nLastCamp = BT_GetData(PT_LAST_CAMP);
	local nLastBattle = BT_GetData(PT_LAST_BATTLE);
	local nLastResult = BT_GetData(PT_LAST_RESULT);
	local nSpyClothTime = BT_GetData(PT_SPYCLOTH_TIME);
	local nTimePassed = GetTime() - nSpyClothTime;
	local nLevel = GetLevel();
	
	if gf_JudgeRoomWeight(3,30) ~= 1 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: H祅h trang c馻 b筺 kh玭g  ch� tr鑞g!");
		return 0;
	end;
	
	if nType ~= 0 then
		if nTimePassed <= ITEM_SPYCLOTH_TIME then
			Talk(1,"","<color=green>"..g_sNpcName.."<color>: Hi謚 qu� m苩 n� Gi竛 謕 c馻 b筺 v蒼 c遪, kh玭g th� s� d鬾g ph莕 thng qu﹏ c玭g nh薾 ph莕 thng. Th阨 gian s� d鬾g m苩 n� Gi竛 謕: <color=yellow>"..tf_GetTimeString(ITEM_SPYCLOTH_TIME-nTimePassed).."<color>.");
			return 0;
		end;
		if DelItem(tbJUNGONGZHANG[nType][2],tbJUNGONGZHANG[nType][3],tbJUNGONGZHANG[nType][4],1) == 1 then
			nJunGongAward = nJunGongAward*tbJUNGONGZHANG[nType][5];
		else
			Talk(1,"get_battle_award","<color=green>"..g_sNpcName.."<color>: Ngi kh玭g mang theo <color=yellow>"..tbJUNGONGZHANG[nType][1].."<color> th� ph秈!");
			return 0;
		end;
	end;
	
	--先清理变量 防止多次领奖
	BT_SetData(PT_POINT_AWARD,0);
	BT_SetData(PT_JUNGONG_AWARD,0);
	BT_SetData(PT_EXP_AWARD,0);
	BT_SetData(PT_GOLDENEXP_AWARD,0);
	BT_SetData(PT_LAST_CAMP,0);
	BT_SetData(PT_SPYCLOTH_TIME,0)
	BT_SetData(PT_LAST_BATTLE,0);
	
	local nDate = tonumber(date("%y%m%d"));
	if nDate > BT_GetData(PT_GET_EXP_AWARD_DATE) then
		BT_SetData(PT_GET_EXP_AWARD_COUNT,0);
	end;
	local tbExpMultiple = --军功章的奖励翻倍倍数
	{
		[0] = 1,
		[1] = 1.5,
		[2] = 2,
		[3] = 2.5,
		[4] = 3,
	};	
	local nGetExpAwardCount = BT_GetData(PT_GET_EXP_AWARD_COUNT);
	if nLastBattle ~= MAINBATTLE_ID then	--如果是小战场
		local nChargeType = BT_CheckCharge(nLastCamp)
		if nChargeType > 0 then
			if nChargeType > 4 then
				nChargeType = nChargeType - 4
			end
			if nChargeType == nLastBattle then
				nExpAward = nExpAward * 2
			end
		end	
		nExpAward = floor(nExpAward*tbExpMultiple[nType]);
		--< Added by SunZhuoshi
		HBRewardInSmallBattleField();
		-->
		ModifyExp(nExpAward);
		Msg2Player("B筺 nh薾 頲 "..nExpAward.." 甶觤 kinh nghi謒");	
		--武林vip令
		_vc_JoinSmallBattle();
	else	--大战场奖励
		--< Added by SunZhuoshi
		HBRewardInBigBattleField();
		-->
		if nGetExpAwardCount < 1 then	--如果获取大战场奖励次数小于1
			nExpAward = floor(nExpAward*tbExpMultiple[nType]);
			ModifyExp(nExpAward);
			Msg2Player("B筺 nh薾 頲 "..nExpAward.." 甶觤 kinh nghi謒");	
			ModifyExp(5000000);
			Msg2Player("B筺 nh薾 th猰 頲 5000000 甶觤 kinh nghi謒");				
			BT_SetData(PT_GET_EXP_AWARD_COUNT,nGetExpAwardCount+1);
			BT_SetData(PT_GET_EXP_AWARD_DATE,nDate);		
		else
			Msg2Player("H玬 nay b筺  nh薾 1 l莕 ph莕 thng kinh nghi謒, m鏸 ng祔 ch� c� th� nh薾 1 l莕");
		end;
		--nhi謒 v� l祄 gi祏
	   	if CFG_NhiemVuLamGiau == 1 then
		     if gf_GetTaskBit(TSK_LAMGIAU, 12) == 1 and gf_GetTaskBit(TSK_LAMGIAU, 10) == 0 then
		     		gf_SetTaskBit(TSK_LAMGIAU, 10, 1, 0)
		     		TaskTip("Ho祅 th祅h nhi謒 v� l祄 gi祏: Ho祅 th祅h nhi謒 v� Nh筺 M玭 R鵦 L鯽.")
		     end		
		end
		--武林vip令
		_vc_JoinBigbattle();
	end;
	-----------------------Chu鏸 nhi謒 v� уng H祅h
	if CFG_NhiemVuDongHanh == 1 then
		if nLastBattle == VILLAGE_ID then
			if DongHanh_GetStatus() == 0 and DongHanh_GetMission() == 5 then
				DongHanh_SetStatus()
			end
		end	
		if nLastBattle == RESOURCE_ID then
			if DongHanh_GetStatus() == 0 and DongHanh_GetMission() == 6 then
				DongHanh_SetStatus()
			end
		end	
		if nLastBattle == EMPLACEMENT_ID then
			if DongHanh_GetStatus() == 0 and DongHanh_GetMission() == 7 then
				DongHanh_SetStatus()
			end
		end	
		if nLastBattle == MAINBATTLE_ID then
			if DongHanh_GetStatus() == 0 and DongHanh_GetMission() == 8 then
				DongHanh_SetStatus()
			end
		end
	end
	---------
	TongLieu_NhanThuong(nLastBattle)	--nh薾 thong � file fearture_award
	---------------------------------
	-- 越南2008 5.1 活动奖励
	local is_main_batter = (nLastBattle == MAINBATTLE_ID) or 0;
	local is_winner = (nLastCamp == nLastResult) or 0
	viet_51_battle_award(is_main_batter, is_winner);
	
	local tYinXiongXunZhang = {
		[0] = {0, 1,},
		[1] = {1, 2,},
		[2] = {2, 3,},
		[3] = {3, 4,},
		[4] = {4, 5,},
	}
	local nYinXiongXunZhangCnt = tYinXiongXunZhang[nType][is_winner+1] or 0
	if nYinXiongXunZhangCnt > 0 then
		gf_SetLogCaption("NewBattle");
    	gf_AddItemEx({2, 1, 30499, nYinXiongXunZhangCnt}, "Hu﹏ chng anh h飊g");
    	gf_SetLogCaption("");
	end

	
	--真气奖励
	AwardZhenQi_ZhanChang(is_main_batter, is_winner)
	
	--越南2009年8月活动奖励，主战场才给
	if tonumber(date("%y%m%d")) >= 090807 and tonumber(date("%y%m%d")) < 090907 then
		local nDayWeek = tonumber(date("%w"));
		if nDayWeek == 0 or nDayWeek == 1 or nDayWeek == 5 or nDayWeek == 6 then 
			if is_main_batter == 1 then
				local nCurRank = BT_GetData(PT_CURRANK);
				nCurRank = abs(nCurRank);
				if nCurRank == 1 then
					ModifyExp(100000);
				elseif nCurRank == 2 then
					ModifyExp(200000);
				elseif nCurRank == 3 then		-- 都统
					ModifyExp(350000 + is_winner * 50000);
				elseif nCurRank == 4 then
					ModifyExp(700000 + is_winner * 100000);
				elseif nCurRank == 5 then
					ModifyExp(1000000 + is_winner * 200000);
				end
			end
		end
	end
	
	if IB_VERSION ~= 1 then	--如果是收费版本，增加健康转经验奖励
		gf_GoldenExp2Exp(nGoldenExpAward);
	end;
	BT_SetData(PT_TOTALPOINT,BT_GetData(PT_TOTALPOINT)+nPointAward);
	SetRankPoint(RANK_BATTLE_POINT,BATTLE_OFFSET+PT_TOTALPOINT,1);	--执行SetRankPoint会衰减军功
	Msg2Player("B筺 nh薾 頲 "..nPointAward.." 甶觤 t輈h l騳 chi課 trng");
	if nTimePassed <= ITEM_SPYCLOTH_TIME then
		nJunGongAward = 0;
		Msg2Player("Hi謚 qu� m苩 n� Gi竛 謕: B筺 kh玭g nh薾 頲 qu﹏ c玭g");
	end;
	nCurRankPoint = BT_GetData(PT_RANKPOINT);	--获取衰减后的军功
	if nLastCamp == SONG_ID then
		BT_SetData(PT_RANKPOINT,nCurRankPoint+nJunGongAward);
	else
		BT_SetData(PT_RANKPOINT,nCurRankPoint-nJunGongAward);
	end;
	SetRankPoint(RANK_BATTLE_CONTRIBUTION,BATTLE_OFFSET+PT_RANKPOINT,1);
	Msg2Player("B筺 nh薾 頲 "..tCampNameZ[nLastCamp].."Phng "..nJunGongAward.." 甶觤 c玭g tr筺g");
	local tMocRuong = {
		[0] = {"Kh玭g", 1},
		[1] = {"Qu﹏ C玭g Chng", 2},
		[2] = {"Qu﹏ C玭g Чi", 4},
		[3] = {"Qu﹏ C玭g Huy Ho祅g", 8},
	}
	gf_AddItemEx2({2,1,30340,tMocRuong[nType][2]},"M閏 Rng lo筰 "..tMocRuong[nType][1],"Th莕 T礽 B秓 Rng","T鑞g Li猽",0,1)
--	Msg2Player("B筺 nh薾 頲 "..tMocRuong[nType][2].." M閏 Rng")	
	--武林功勋
	if nLastBattle ~= MAINBATTLE_ID then	--如果是小战场
		if nLastCamp == nLastResult then
			merit_SmallBattle(1, nType);
		else
			merit_SmallBattle(0, nType);
		end
	else
		if nLastCamp == nLastResult then
			merit_BigBattle(1, nType);
		else
			merit_BigBattle(0, nType);
		end
	end
end;

function not_use_jungongzhang_confirm()
	local selTab = {
				"S� d鬾g qu﹏ c玭g chng/get_battle_award",
				"Kh玭g mu鑞 d飊g qu﹏ c玭g n祇 h誸/#not_use_jungongzhang_confirm2(0)",
				}
	Say("<color=green>"..g_sNpcName.."<color>: Ngi kh玭g d飊g qu﹏ c玭g chng sao?",getn(selTab),selTab);
end;

function not_use_jungongzhang_confirm2()
	local nCurCamp = BT_GetCurCamp();
	local nLastCamp = BT_GetData(PT_LAST_CAMP);
	local nSpyClothTime = BT_GetData(PT_SPYCLOTH_TIME);
	local nTimePassed = GetTime() - nSpyClothTime;
	if nLastCamp == nCurCamp or nTimePassed <= ITEM_SPYCLOTH_TIME then	--如果参加的是本方阵营或间谍装束在有效时间内
		get_all_award(0);
		return 0;
	end;
	local selTab = {
				"уng �/#get_all_award(0)",
				"Tho竧/nothing",
				}
	Say("<color=green>"..g_sNpcName.."<color>: B筺 tham gia chi課 trng phe i phng, tr鵦 ti誴 nh薾 thng s� b� kh蕌 tr� 甶觤 qu﹏ c玭g, c� th� s� d鬾g <color=yellow>m苩 n� Gi竛 謕<color> l祄 qu﹏ c玭g b筺 b� kh蕌 tr� th祅h 0. N誹 b筺 v蒼 mu鑞 nh薾 ph莕 thng h穣 ch鋘 x竎 nh薾, n誹 b筺 mu鑞 suy ngh� th猰 hay ch鋘 R阨 kh醝.",getn(selTab),selTab);
end;

function assess_rank()
	local selTab = {
			"Ta mu鑞 nh薾 qu﹏ h祄 qu﹏ c玭g tu莕 n祔/battle_shouxian",
			"фi m韎 qu﹏ h祄/update_cur_rank",
			"Quay l筰 n閕 dung trc./main",
			"K誸 th骳 i tho筰/nothing",
			}
	Say("<color=green>"..g_sNpcName.."<color>: Ngi mu鑞 tham gia trao qu﹏ h祄 tu莕 n祔 �?",getn(selTab),selTab);
end;

function battle_regular_award()
	local selTab = {
				"фi trang b� chi課 trng/BTA_Main",
				"Ta mu鑞 i 100000 甶觤 t輈h l騳 l蕐 H� y c馻 T祅g Ki誱 c蕄 70/want_cangjian_equip",
				"Ta mu鑞 i 30000 甶觤 t輈h l騳 l蕐 L謓h b礽 bang h閕/want_ling_pai",
				"Ta mu鑞i 1000 甶觤 t輈h l騳 l蕐 甶觤 kinh nghi謒/want_exp_award",
				"Quay l筰 n閕 dung trc./main",
				"K誸 th骳 i tho筰/nothing",
				}
	if IB_VERSION == 1 then	--IB版本没有积分换装备、经验、会盟令牌奖励
		tremove(selTab,2);
		tremove(selTab,3);
--		tremove(selTab,2);
	end;
	Say("<color=green>"..g_sNpcName.."<color>: Ngi mu鑞 i ph莕 thng n祇?",getn(selTab),selTab);
end;

function want_ling_pai()
	local selTab = {
			"уng �/give_ling_pai",
			"H駓 b�/nothing",
			}
	Say("<color=green>"..g_sNpcName.."<color>: фi <color=yellow>L謓h b礽 bang h閕<color> c莕 <color=yellow>30000 甶觤 t輈h l騳<color>, b筺 x竎 nh薾 mu鑞 i?",getn(selTab),selTab);
end;

function give_ling_pai()
	local nCurPoint = BT_GetData(PT_TOTALPOINT);
	local nNeedPoint = 30000;
	if nCurPoint < nNeedPoint then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: Xin l鏸! 觤 t輈h l騳 c馻 b筺 kh玭g  ");
		return 0;
	end;
	if gf_JudgeRoomWeight(1,30) ~= 1 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: H祅h trang c馻 b筺 kh玭g  ch� tr鑞g!");
		return 0;
	end;
	BT_SetData(PT_TOTALPOINT,nCurPoint-nNeedPoint);
	local nRetCode = AddItem(2,0,125,1);
	if nRetCode == 1 then
		Msg2Player("B筺  i m閠 L謓h b礽 bang h閕");
		WriteLog("[ph莕 thng chi課 tr薾]:"..GetName().."  i m閠 l謓h b礽 bang h閕");
	else
		WriteLog("[ph莕 thng b� l鏸]"..GetName().."Khi i l謓h b礽 bang h閕 AddItem b竜 l鏸, nRetCode:"..nRetCode);
	end;
end;

function want_cangjian_equip()
	local selTab = {
			"уng �/give_cangjian_equip",
			"H駓 b�/nothing",
			}
	Say("<color=green>"..g_sNpcName.."<color>: Mu鑞 i <color=yellow>H� y T祅g Ki誱 c蕄 70<color> c莕 <color=yellow>100000 甶觤 t輈h l騳<color>, b筺 x竎 nh薾 mu鑞 i?",getn(selTab),selTab);
end;

function give_cangjian_equip()
	local nCurPoint = BT_GetData(PT_TOTALPOINT);
	local nNeedPoint = 100000;
	if nCurPoint < nNeedPoint then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: Xin l鏸! 觤 t輈h l騳 c馻 b筺 kh玭g  ");
		return 0;
	end;
	if gf_JudgeRoomWeight(1,100) ~= 1 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: H祅h trang c馻 b筺 kh玭g  ch� tr鑞g!");
		return 0;
	end;
	if gf_CheckPlayerRoute() ~= 1 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: B筺 ph秈 gia nh藀 m玭 ph竔 m韎 c� th� i H� y T祅g Ki誱");
		return 0;
	end;
	local nRoute = GetPlayerRoute();
	local nBody = GetBody();
	local nNum = nRoute * 100 + 70 + nBody;
	BT_SetData(PT_TOTALPOINT,nCurPoint-nNeedPoint);
	local nRetCode = AddItem(0,101,nNum,1,1,-1,-1,-1,-1,-1,-1);
	if nRetCode == 1 then
		Msg2Player("B筺 i "..nNeedPoint.." 甶觤 t輈h l騳 l蕐 1 H� y T祅g Ki誱 c蕄 70");
		WriteLog("[ph莕 thng chi課 tr薾]:"..GetName().." i l蕐 H� y T祅g Ki誱 c蕄 70");
	else
		WriteLog("[ph莕 thng b� l鏸]"..GetName().."фi l蕐 H� y T祅g Ki誱 c蕄 70 AddItem b竜 l鏸, nRetCode:"..nRetCode);
	end;
end;

function want_exp_award()
	local nCurPoint = BT_GetData(PT_TOTALPOINT);
	local nNeedPoint = 1000;
	local nLevel = GetLevel();
	if nLevel < 40 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: Xin l鏸! Nh﹏ v藅 di c蕄 <color=yellow>40<color> kh玭g th� i ph莕 thng kinh nghi謒");
		return 0;
	end;
	local nDate = tonumber(date("%y%m%d"));
	if nDate > BT_GetData(PT_EXCHANGE_EXP_DATE) then
		BT_SetData(PT_EXCHANGE_EXP_COUNT,0);
	end;
	local nCurCount = BT_GetData(PT_EXCHANGE_EXP_COUNT);
	if nCurCount >= 20 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: Xin l鏸! H玬 nay b筺  nh薾 <color=yellow>20<color> l莕 ph莕 thng 甶觤 kinh nghi謒, m鏸 ng祔 ch� c� th� i 甶觤 t輈h l騳 l蕐 甶觤 kinh nghi謒 20 l莕");
		return 0;
	end;
	if nCurPoint < nNeedPoint then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: Xin l鏸! 觤 t輈h l騳 c馻 b筺 kh玭g  ");
		return 0;
	end;
	local nExpAward = floor((((nLevel^2)/1600)^2)*20000);
	nCurCount = nCurCount + 1;
	BT_SetData(PT_TOTALPOINT,nCurPoint-nNeedPoint);
	BT_SetData(PT_EXCHANGE_EXP_COUNT,nCurCount);
	BT_SetData(PT_EXCHANGE_EXP_DATE,nDate);
	ModifyExp(nExpAward);
	Msg2Player("B筺 i "..nNeedPoint.." 甶觤 t輈h l騳 i l蕐 "..nExpAward.." 甶觤 kinh nghi謒, y l� l莕 i 甶觤 kinh nghi謒 th� "..nCurCount..".");
	WriteLog("[ph莕 thng chi課 tr薾]:"..nLevel.."-(c蕄):"..GetName().."  d飊g 甶觤 t輈h l騳 i"..nExpAward.." 甶觤 kinh nghi謒");
end;

function change_camp()
	local nDate = tonumber(date("%y%m%d"));
	if nDate > 070920 then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: Th阨 gian i phe mi詎 ph�  qua, c竎 v� i hi謕 h穣 c萵 tr鋘g khi ch鋘 phe!");
		return 0;
	end;
	if BT_GetData(PT_CHANGE_CAMP_COUNT) >= MAX_CHANGE_CAMP then
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: B筺  i qu﹏ c玭g <color=yellow>"..MAX_CHANGE_CAMP.."<color> l莕, kh玭g th� i ti誴.");
		return 0;
	end;
	local selTab = {
				"T鑞g/#change_camp_confirm(1)",
				"Li猽/#change_camp_confirm(2)",
				"Ta suy ngh� l筰/nothing",
				}
	local nJunGong = BT_GetData(PT_RANKPOINT);
	local szStr = "";
	if nJunGong < 0 then
		szStr = "B筺 產ng thu閏 phe Li猽, qu﹏ c玭g hi謓 t筰:"..abs(nJunGong)..".";
	elseif nJunGong > 0 then
		szStr = "B筺 產ng thu閏 phe T鑞g, qu﹏ c玭g hi謓 t筰:"..abs(nJunGong)..".";
	else
		Talk(1,"","<color=green>"..g_sNpcName.."<color>: Qu﹏ c玭g hi謓 t筰 c馻 b筺 l� 0, kh玭g c莕 ph秈 chuy觧 qu﹏ c玭g.");
		return 0;
	end;
	local nChangeCampCount = BT_GetData(PT_CHANGE_CAMP_COUNT);
	Say("<color=green>"..g_sNpcName.."<color>: "..szStr.."Ngi mu鑞 c鑞g hi課 cho phe n祇? <color=yellow>Trc 20/9<color> ta c� th� gi髉 ngi i qu﹏ c玭g mi詎 ph� 3 l莕. Hi謓 gi� ngi c� th� chuy觧 i qu﹏ c玭g <color=yellow>"..(MAX_CHANGE_CAMP-nChangeCampCount).."<color> l莕.",getn(selTab),selTab);
end;

function change_camp_confirm(nCamp)
	local nJunGong = BT_GetData(PT_RANKPOINT);
	local szStr = "";
	local nChangeCampCount = BT_GetData(PT_CHANGE_CAMP_COUNT);
	if nJunGong <= 0 then
		if nCamp == LIAO_ID then
			Talk(1,"","<color=green>"..g_sNpcName.."<color>: Ngi  l� Tng s� phe Li猽, kh玭g c莕 chuy觧 i qu﹏ c玭g!");
			return 0;
		end;
		szStr = "B筺  i sang phe T鑞g, qu﹏ c玭g c馻 b筺 l�: <color=yellow>"..abs(nJunGong).."<color>. B筺 c遪 <color=yellow>"..(MAX_CHANGE_CAMP-nChangeCampCount-1).."<color> l莕 i phe mi詎 ph�";
	elseif nJunGong > 0 then
		if nCamp == SONG_ID then
			Talk(1,"","<color=green>"..g_sNpcName.."<color>: Ngi  l� Tng s� phe T鑞g, kh玭g c莕 chuy觧 i qu﹏ c玭g!");
			return 0;
		end;	
		szStr = "B筺  i sang phe Li猽, qu﹏ c玭g c馻 b筺 l�: <color=yellow>"..abs(nJunGong).."<color>. B筺 c遪 <color=yellow>"..(MAX_CHANGE_CAMP-nChangeCampCount-1).."<color> l莕 i phe mi詎 ph�";
	end;
	BT_SetData(PT_RANKPOINT,-nJunGong);
	BT_SetData(PT_CHANGE_CAMP_COUNT,nChangeCampCount+1);
	Talk(1,"","<color=green>"..g_sNpcName.."<color>: "..szStr);
end;
