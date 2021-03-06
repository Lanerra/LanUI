local _G = getfenv(0)

local MAJOR = "LibBossEncounters"
local MINOR = 1
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end

local ENCOUNTER_IDS

function lib:IsValidBossID(mob_id)
	if not mob_id or _G.type(mob_id) ~= "number" then
		return false
	end
	return ENCOUNTER_IDS[mob_id]
end

local BossIDs = {
    [4887] = true,
    [4831] = true,
    [6243] = true,
    [12902] = true,
    [12876] = true,
    [4832] = true,
    [4830] = true,
    [4829] = true,
    [9025] = true,
    [9016] = true,
    [9319] = true,
    [9018] = true,
    [9027] = true,
    [9028] = true,
    [9029] = true,
    [9030] = true,
    [9031] = true,
    [9032] = true,
    [9024] = true,
    [9033] = true,
    [8983] = true,
    [9543] = true,
    [9537] = true,
    [9499] = true,
    [9502] = true,
    [9017] = true,
    [9056] = true,
    [9041] = true,
    [9042] = true,
    [9438] = true,
    [9442] = true,
    [9443] = true,
    [9439] = true,
    [9437] = true,
    [9441] = true,
    [9156] = true,
    [9034] = true,
    [9035] = true,
    [9036] = true,
    [9037] = true,
    [9038] = true,
    [9039] = true,
    [9040] = true,
    [9938] = true,
    [8929] = true,
    [9019] = true,
    [9816] = true,
    [10339] = true,
    [10429] = true,
    [10430] = true,
    [10363] = true,
    [9196] = true,
    [9236] = true,
    [9237] = true,
    [10596] = true,
    [10584] = true,
    [9736] = true,
    [10268] = true,
    [10220] = true,
    [9568] = true,
    [12435] = true,
    [13020] = true,
    [12017] = true,
    [11983] = true,
    [14601] = true,
    [11981] = true,
    [14020] = true,
    [11583] = true,
    [11490] = true,
    [13280] = true,
    [14327] = true,
    [11492] = true,
    [14326] = true,
    [14322] = true,
    [14321] = true,
    [14323] = true,
    [14325] = true,
    [11501] = true,
    [14324] = true,
    [11489] = true,
    [11488] = true,
    [11487] = true,
    [11496] = true,
    [11486] = true,
    [7079] = true,
    [7361] = true,
    [6235] = true,
    [6229] = true,
    [7800] = true,
    [13282] = true,
    [12258] = true,
    [12236] = true,
    [12225] = true,
    [12203] = true,
    [13601] = true,
    [13596] = true,
    [12201] = true,
    [12118] = true,
    [11982] = true,
    [12259] = true,
    [12057] = true,
    [12264] = true,
    [12056] = true,
    [11988] = true,
    [12098] = true,
    [12018] = true,
    [11502] = true,
    [10184] = true,
    [11517] = true,
    [11518] = true,
    [11519] = true,
    [11520] = true,
    [17830] = true,
    [7355] = true,
    [7357] = true,
    [8567] = true,
    [7358] = true,
    [6168] = true,
    [4424] = true,
    [4428] = true,
    [4420] = true,
    [4422] = true,
    [4421] = true,
    [15348] = true,
    [15341] = true,
    [15340] = true,
    [15370] = true,
    [15369] = true,
    [15339] = true,
    [46383] = true,
    [46264] = true,
    [46254] = true,
    [10516] = true,
    [10558] = true,
    [10808] = true,
    [11032] = true,
    [10997] = true,
    [10811] = true,
    [10813] = true,
    [10436] = true,
    [10437] = true,
    [10438] = true,
    [10435] = true,
    [10439] = true,
    [45412] = true,
    [15263] = true,
    [15516] = true,
    [15510] = true,
    [15509] = true,
    [15275] = true,
    [15276] = true,
    [15727] = true,
    [15511] = true,
    [15543] = true,
    [15544] = true,
    [15299] = true,
    [15517] = true,
    [5710] = true,
    [8440] = true,
    [5709] = true,
    [6910] = true,
    [6906] = true,
    [6907] = true,
    [6908] = true,
    [7228] = true,
    [7023] = true,
    [7206] = true,
    [7291] = true,
    [4854] = true,
    [2748] = true,
    [3671] = true,
    [3669] = true,
    [3653] = true,
    [3670] = true,
    [3674] = true,
    [3673] = true,
    [5775] = true,
    [3654] = true,
    [8127] = true,
    [7272] = true,
    [7271] = true,
    [7796] = true,
    [7795] = true,
    [7273] = true,
    [7275] = true,
    [7797] = true,
    [7267] = true,
    [18371] = true,
    [18373] = true,
    [18341] = true,
    [18343] = true,
    [18344] = true,
    [22930] = true,
    [18472] = true,
    [18473] = true,
    [23035] = true,
    [18731] = true,
    [18667] = true,
    [18732] = true,
    [18708] = true,
    [22887] = true,
    [22898] = true,
    [22841] = true,
    [22871] = true,
    [22948] = true,
    [23420] = true,
    [22947] = true,
    [22949] = true,
    [22950] = true,
    [22951] = true,
    [22952] = true,
    [22917] = true,
    [17767] = true,
    [17808] = true,
    [17888] = true,
    [17842] = true,
    [17968] = true,
    [17848] = true,
    [17862] = true,
    [18096] = true,
    [17879] = true,
    [17880] = true,
    [17881] = true,
    [21216] = true,
    [21217] = true,
    [21215] = true,
    [21214] = true,
    [21213] = true,
    [21212] = true,
    [17941] = true,
    [17991] = true,
    [17942] = true,
    [17797] = true,
    [17796] = true,
    [17798] = true,
    [17770] = true,
    [18105] = true,
    [17826] = true,
    [17882] = true,
    [18831] = true,
    [18832] = true,
    [18834] = true,
    [18835] = true,
    [18836] = true,
    [19044] = true,
    [17306] = true,
    [17308] = true,
    [17536] = true,
    [17537] = true,
    [17257] = true,
    [17381] = true,
    [17380] = true,
    [17377] = true,
    [16807] = true,
    [20923] = true,
    [16809] = true,
    [16808] = true,
    [18728] = true,
    [17711] = true,
    [15550] = true,
    [16151] = true,
    [15687] = true,
    [16457] = true,
    [15691] = true,
    [15688] = true,
    [16524] = true,
    [15689] = true,
    [15690] = true,
    [17225] = true,
    [17229] = true,
    [16179] = true,
    [16181] = true,
    [16180] = true,
    [17535] = true,
    [17546] = true,
    [17543] = true,
    [17547] = true,
    [17548] = true,
    [18168] = true,
    [17521] = true,
    [17533] = true,
    [17534] = true,
    [24723] = true,
    [24744] = true,
    [24560] = true,
    [24664] = true,
    [24850] = true,
    [24892] = true,
    [24882] = true,
    [25038] = true,
    [25165] = true,
    [25166] = true,
    [25840] = true,
    [25315] = true,
    [20870] = true,
    [20885] = true,
    [20886] = true,
    [20912] = true,
    [17976] = true,
    [17975] = true,
    [17978] = true,
    [17980] = true,
    [17977] = true,
    [19516] = true,
    [19514] = true,
    [18805] = true,
    [19622] = true,
    [20064] = true,
    [20060] = true,
    [20062] = true,
    [20063] = true,
    [19219] = true,
    [19221] = true,
    [19220] = true,
    [29308] = true,
    [29309] = true,
    [29310] = true,
    [29311] = true,
    [30258] = true,
    [28684] = true,
    [28921] = true,
    [29120] = true,
    [26529] = true,
    [26530] = true,
    [26532] = true,
    [26533] = true,
    [32273] = true,
    [26630] = true,
    [26631] = true,
    [26632] = true,
    [27483] = true,
    [36497] = true,
    [36502] = true,
    [29304] = true,
    [29305] = true,
    [29306] = true,
    [29307] = true,
    [29573] = true,
    [29932] = true,
    [28546] = true,
    [28586] = true,
    [28587] = true,
    [28923] = true,
    [37226] = true,
    [38112] = true,
    [38113] = true,
    [27975] = true,
    [27977] = true,
    [27978] = true,
    [28234] = true,
    [36612] = true,
    [36855] = true,
    [37813] = true,
    [36626] = true,
    [36627] = true,
    [36678] = true,
    [37955] = true,
    [37970] = true,
    [37972] = true,
    [37973] = true,
    [36789] = true,
    [36853] = true,
    [37533] = true,
    [37534] = true,
    [36597] = true,
    [15956] = true,
    [15953] = true,
    [15952] = true,
    [15954] = true,
    [15936] = true,
    [16011] = true,
    [16061] = true,
    [16060] = true,
    [16064] = true,
    [16065] = true,
    [30549] = true,
    [16063] = true,
    [16028] = true,
    [15931] = true,
    [15932] = true,
    [15928] = true,
    [15989] = true,
    [15990] = true,
    [28860] = true,
    [30449] = true,
    [30451] = true,
    [30452] = true,
    [36494] = true,
    [36476] = true,
    [36477] = true,
    [36658] = true,
    [39746] = true,
    [39747] = true,
    [39751] = true,
    [39863] = true,
    [28859] = true,
    [26723] = true,
    [26731] = true,
    [26763] = true,
    [26794] = true,
    [26796] = true,
    [26798] = true,
    [27447] = true,
    [27654] = true,
    [27655] = true,
    [27656] = true,
    [29266] = true,
    [29312] = true,
    [29313] = true,
    [29314] = true,
    [29315] = true,
    [29316] = true,
    [31134] = true,
    [35617] = true,
    [35569] = true,
    [35572] = true,
    [35571] = true,
    [35570] = true,
    [34702] = true,
    [34701] = true,
    [34705] = true,
    [34657] = true,
    [34703] = true,
    [34928] = true,
    [35119] = true,
    [35451] = true,
    [34796] = true,
    [35144] = true,
    [34799] = true,
    [34797] = true,
    [34780] = true,
    [34461] = true,
    [34460] = true,
    [34469] = true,
    [34467] = true,
    [34468] = true,
    [34465] = true,
    [34471] = true,
    [34466] = true,
    [34473] = true,
    [34472] = true,
    [34470] = true,
    [34463] = true,
    [34474] = true,
    [34475] = true,
    [34458] = true,
    [34451] = true,
    [34459] = true,
    [34448] = true,
    [34449] = true,
    [34445] = true,
    [34456] = true,
    [34447] = true,
    [34441] = true,
    [34454] = true,
    [34444] = true,
    [34455] = true,
    [34450] = true,
    [34453] = true,
    [35610] = true,
    [35465] = true,
    [34497] = true,
    [34496] = true,
    [34564] = true,
    [33113] = true,
    [33118] = true,
    [33186] = true,
    [33293] = true,
    [32867] = true,
    [32927] = true,
    [32857] = true,
    [32930] = true,
    [33515] = true,
    [32906] = true,
    [32845] = true,
    [33350] = true,
    [32865] = true,
    [33271] = true,
    [33288] = true,
    [32871] = true,
    [23953] = true,
    [24200] = true,
    [24201] = true,
    [23980] = true,
    [26668] = true,
    [26687] = true,
    [26693] = true,
    [26861] = true,
    [31125] = true,
    [33993] = true,
    [35013] = true,
    [38433] = true,
    [39665] = true,
    [39679] = true,
    [39698] = true,
    [39700] = true,
    [39705] = true,
    [39625] = true,
    [40177] = true,
    [40319] = true,
    [40484] = true,
    [39378] = true,
    [39425] = true,
    [39428] = true,
    [39587] = true,
    [39731] = true,
    [39732] = true,
    [39788] = true,
    [43612] = true,
    [43614] = true,
    [44577] = true,
    [44819] = true,
    [49045] = true,
    [3887] = true,
    [4278] = true,
    [46962] = true,
    [46963] = true,
    [46964] = true,
    [43778] = true,
    [47162] = true,
    [47296] = true,
    [47626] = true,
    [47739] = true,
    [49541] = true,
    [42188] = true,
    [42333] = true,
    [43214] = true,
    [43438] = true,
    [43873] = true,
    [43875] = true,
    [43878] = true,
    [40586] = true,
    [40655] = true,
    [40765] = true,
    [40788] = true,
    [23574] = true,
    [23576] = true,
    [23578] = true,
    [23577] = true,
    [24239] = true,
    [23863] = true,
    [52155] = true,
    [52151] = true,
    [52059] = true,
    [52053] = true,
    [52148] = true,
    [52271] = true,
    [52269] = true,
    [52286] = true,
    [52258] = true,
    [55869] = true,
    [47120] = true,
    [52363] = true,
    [43324] = true,
    [43735] = true,
    [44600] = true,
    [45213] = true,
    [45992] = true,
    [45993] = true,
    [41376] = true,
    [41378] = true,
    [41442] = true,
    [41570] = true,
    [42166] = true,
    [42178] = true,
    [42179] = true,
    [42180] = true,
    [43296] = true,
    [55265] = true,
    [55308] = true,
    [55312] = true,
    [55689] = true,
    [55294] = true,
    [56427] = true,
    [53879] = true,
    [56173] = true,
    [54431] = true,
    [54445] = true,
    [54123] = true,
    [54544] = true,
    [54432] = true,
    [52498] = true,
    [52558] = true,
    [52530] = true,
    [53691] = true,
    [53494] = true,
    [52571] = true,
    [52409] = true,
    [54938] = true,
    [54590] = true,
    [54968] = true,
    [45870] = true,
    [45871] = true,
    [45872] = true,
    [46753] = true,
    [55085] = true,
    [54853] = true,
    [55419] = true,
    [54969] = true,
    [56906] = true,
    [56589] = true,
    [56636] = true,
    [56877] = true,
    [61442] = true,
    [61444] = true,
    [61445] = true,
    [61243] = true,
    [61398] = true,
    [59303] = true,
    [58632] = true,
    [59150] = true,
    [59789] = true,
    [59223] = true,
    [60040] = true,
    [3977] = true,
    [58633] = true,
    [59184] = true,
    [59153] = true,
    [58722] = true,
    [59080] = true,
    [56747] = true,
    [56541] = true,
    [56719] = true,
    [56884] = true,
    [61567] = true,
    [61634] = true,
    [61485] = true,
    [62205] = true,
    [56637] = true,
    [56717] = true,
    [59479] = true,
    [56448] = true,
    [56843] = true,
    [56732] = true,
    [56439] = true,
    [66791] = true,
    [63664] = true,
    [63667] = true,
    [65501] = true,
    [62711] = true,
    [63666] = true,
    [60047] = true,
    [60051] = true,
    [60043] = true,
    [59915] = true,
    [60009] = true,
    [60143] = true,
    [61421] = true,
    [61429] = true,
    [61423] = true,
    [61427] = true,
    [60410] = true,
    [60400] = true,
    [60399] = true,
    [60583] = true,
    [60586] = true,
    [60585] = true,
    [62442] = true,
    [62983] = true,
    [60999] = true,
    [69465] = true,
    [68476] = true,
    [69078] = true,
    [69131] = true,
    [69132] = true,
    [69134] = true,
    [67977] = true,
    [70212] = true,
    [70235] = true,
    [70247] = true,
    [69712] = true,
    [68036] = true,
    [69017] = true,
    [69427] = true,
    [68078] = true,
    [68904] = true,
    [68905] = true,
}

lib.BossIDs = BossIDs