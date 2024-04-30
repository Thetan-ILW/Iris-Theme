local localization = {}

localization.language = "English"

localization.textHeader = {
	settings = "Settings",
	songs = "Songs",
	collections = "Collections",
	notLoggedIn = "Offline",
	online = "Online: %i",
}

localization.textSettings = {
	gameplayTab = "Gameplay",
	audioTab = "Audio",
	videoTab = "Video",
	timingsTab = "Timings",
	keybindsTab = "Keybinds",
	inputsTab = "Inputs",
	uiTab = "UI",
	versionTab = "Version",
	--
	scrollSpeed = "Scroll speed",
	speedType = "Speed type",
	actionOnFail = "Action on fail",
	actionNone = "None",
	actionPause = "Pause",
	actionQuit = "Quit",
	scaleScrollSpeed = "Scale scroll speed with rate",
	lnShortening = "LN shortening",
	tempoFactor = "Tempo factor",
	primaryTempo = "Primary tempo",
	lastMeanValues = "Last mean values",
	taikoSV = "Taiko SV",
	hp = "Gauge/HP",
	hpShift = "Auto shift",
	hpNotes = "Max health",
	waitTime = "Wait time (in seconds)",
	prepare = "Prepare",
	playPause = "Play->Pause",
	pausePlay = "Pause->Play",
	playRetry = "Play->Retry",
	pauseRetry = "Pause->Retry",
	--
	ratingHitWindow = "Rating hit window",
	inputOffest = "Input offset",
	visualOffset = "Visual offset",
	multiplyInputOffset = "Multiply input offset by time rate",
	multiplyVisualOffset = "Multiply visual offset by time rate",
	--
	volumeType = "Volume type",
	logarithmic = "Logarithmic",
	master = "Master",
	music = "Music",
	effects = "Effects",
	metronome = "Metronome",
	uiVolume = "UI",
	audioPitch = "Time rate changes pitch",
	autoKeySound = "Auto key sound",
	adjustRate = "Timer adjust rate",
	midiConstantVolume = "MIDI constant volume",
	latency = "Latency: ",
	updatePeriod = "Update period",
	bufferLength = "Buffer length",
	apply = "Apply",
	reset = "Reset",
	--
	fpsLimit = "FPS limit",
	fullscreen = "Fullscreen",
	fullscreenType = "Fullscreen type",
	vsync = "Vsync",
	vsyncOnSelect = "Vsync in Song Select Screen",
	dwmFlush = "DWM flush",
	threadedInput = "Threaded input",
	startupWindowResolution = "Window resolution at startup",
	cursor = "Cursor",
	backgroundAnimation = "Background animation",
	video = "Video",
	image = "Image",
	camera = "Camera",
	enableCamera = "Enable camera",
	allowRotateX = "Allow rotation of X coordinate",
	allowRotateY = "Allow rotation of Y coordinate",
	--
	offset = "Offset",
	timeRate = "Time rate",
	pause = "Pause",
	none = "None",
	quit = "Quit",
	skipIntro = "Skip intro",
	quickRestart = "Restart",
	increase = "Increase",
	decrease = "Decrease",
	selectRandom = "Select random",
	captureScreenshot = "Capture screenshot",
	openScreenshot = "Open screenshot",
	--
	dim = "Dim",
	blur = "Blur",
	showOnlineCount = "Show online players count",
	showSpectrum = "Show spectrum analyzer",
	backgroundEffects = "Background effects",
	panelBlur = "Blur under panels",
	ch_ab = "Chromatic aberration",
	distortion = "Distortion",
	spectrum = "Spectrum analyzer color",
	solid = "Solid color",
	inverted = "Inverted color",
	select = "Song Select",
	collections = "Collections",
	gameplay = "Gameplay",
	result = "Result",
	groupCharts = "Group charts",
	alwaysShowOriginalMode = "Always show original input mode",
	rateType = "Time rate type",
	linear = "Linear",
	exp = "Exp",
	language = "Language (RESTART REQUIRED)",
	colorTheme = "Color theme",
	vimMotions = "Vim motions",
	scrollAcceleration = "Scroll acceleration",
	scrollClickExtraTime = "Scroll click extra time",
	transitionAnimation = "Transition animation",
	fade = "Fade",
	shutter = "Shutter",
	--
	osuResultScreen = "osu! result screen",
	enable = "Enable",
	showHpGraph = "Show HP graph",
	showPP = "Show PP",
	skin = "Skin",
	--
	commit = "Commit: ",
	commitDate = "Date: ",
	contributors = "Big thanks to contributors:",
	--
	scoring = "Scoring",
	scoreSystem = "Score system",
	judgement = "Judgement",
	nearest = "Closest note scoring",
	noteHitWindow = "Note hit window",
	noteMissWindow = "Note miss window",
	lnHitWindow = "LN hit window",
	lnMissWindow = "LN miss window",
	early = " (Early)",
	late = " (Late)",
	releaseHitWindow = "Release hit window",
	releaseMissWindow = "Release miss window",
	--
	default = "Default",
	osu = "osu!",
	average = "Average",
	primary = "Primary",
	minimum = "Minimum",
	maximum = "Maximum",
	desktop = "Desktop",
	exclusive = "Exclusive",
	enabled = "Enabled",
	disabled = "Disabled",
	adaptive = "Adaptive",
	circle = "Circle",
	arrow = "Arrow",
	system = "System",
	other = "Other",
	volume = "Volume",
	audioDevice = "Audio device",
	bpm = "%i BPM",
	noMods = "No modifiers",
	const = "Constant scroll speed",
	singleNoteHandler = "Taiko note handler",
	muteOnUnfocus = "Mute game out of focus",
	autoUpdate = "Auto update",
	showNonManiaCharts = "Show non-mania charts",
	difficulty = "Difficulty",
	startSound = "Start sound",
	staticCursor = "Static cursor in lists",
	showLocations = "Show locations",
	chartFormatOffsets = "Offsets for chart formats",
	audioModeOffsets = "Offsets for audio modes",
	chartLengthBeforeArtist = "Show chart length in chart list",
}

localization.textSongSelect = {
	length = "%s LENGTH",
	notes = "%s NOTES",
	bpm = "%i BPM",
	ln = "%i%% LN",
	searchPlaceholder = "Type to search...",
	filterPlaceholder = "No filters.",
	score = "Score: %i",
	noPatterns = "No patterns",
}

localization.textCollections = {
	cache = "Cache",
	collections = "Collections",
	osuDirect = "osu!direct",
	mounts = "Mounts",
	download = "Download",
	redownload = "Redownload",
	wait = "Wait...",
	osuDirectSearchPlaceholder = "Type to search...",
}

localization.textChartList = {
	noItems = "No charts!",
}

localization.textScoreList = {
	noItems = "No scores!",
	noMods = "No mods",
	hasMods = "Has mods",
}

localization.textChartSetsList = {
	noItems = "No chart sets!",
}

localization.textQueueList = {
	noItems = "Queue is empty!",
}

localization.textOsuDirectList = {
	noItems = "Not in osu!direct mode!",
}

localization.textCollectionsList = {
	noItems = "No collections!",
}

localization.textModifiersList = {
	noItems = "No selected mods!",
}

localization.textAvailableModifiersList = {
	noItems = "Your game is broken if you see this.",
}

localization.textInputsList = {
	noItems = "No chart selected.\nCannot determine input mode.",
}

localization.textNoteSkinsList = {
	noItems = "No note skins.",
}

localization.textRoomsList = {
	noItems = "No rooms.\nCreate one and invite your friends!",
	playing = "Playing",
	join = "Join",
	host = "Host: %s",
	room = "Room: %s",
}

localization.textMountsList = {
	noItems = "No mounts!",
}

localization.textModifiers = {
	modifiers = "Modifiers",
}

localization.textNoteSkins = {
	noteSkins = "Note skins",
	noSettings = "No settings!",
}

localization.textInputs = {
	inputs = "Inputs",
}

localization.textMounts = {
	mounts = "Mounts",
	update = "Update",
	deleteCache = "Delete cache",
	processingCharts = "Processing charts...",
	path = "Path",
	chartsFound = "Processed / Found",
	chartsCached = "Charts cached",
	create = "Create",
	delete = "Delete",
	locations = "Locations",
	database = "Database",
	chartdiffs = "Chart difficulty / rating",
	chartmetas = "Chart metadata",
	compute = "Compute",
	computed = "Computed: %i",
}

localization.textOnline = {
	notLoggedIn = "Connect to the server:",
	loggedIn = "You are connected to the server.",
	connect = "Sign in",
	quickConnect = "Login with browser",
	logout = "Log out",
	emailPlaceholder = "Email",
	passwordPlaceholder = "Password",
}

localization.textOsuApi = {
	loading = "Loading...",
	noScores = "No scores!",
	wait = "Wait...",
	noToken = "No access token.",
	noId = "No beatmap ID",
}

localization.textFilters = {
	filters = "Filters",
	moddedCharts = "Show modified charts",
	chartCount = "%i charts in '%s'",
	charts = "Charts",
	scores = "Scores",
	scoresSource = "Source of scores",
	inputMode = "Mode",
	actualInputMode = "Exact mode",
	format = "Format",
	scratch = "Scratch",
	played = "Played",
	sort = "Sort",
	osuDirect = "osu!direct",
	rankedStatus = "Ranked status",
}

localization.textResult = {
	timeRate = "Time rate: %0.02fx",
	pauses = "Pauses:",
	grade = "Grade:",
	scrollSpeed = "Scroll speed:",
	hitWindow = "Hit window",
	missWindow = "Miss window",
	releaseMultiplier = "Release multiplier",
	hitLogic = "Hit logic",
	nearest = "Nearest",
	earliestNote = "Earliest note",
	noPatterns = "No patterns",
	mode = "Mode: ",
	score = "Score: ",
	accuracy = "Accuracy: ",
	rating = "Rating: ",
	mean = "Mean: ",
	maxError = "Max error: ",
}

localization.textOsuResult = {
	chartBy = "Chart by %s",
	chartFrom = "Chart from %s",
	playedBy = "Played by %s on %s",
	mean = "Mean: %s",
	maxError = "Max error: %s",
	scrollSpeed = "Scroll speed: %s",
	mods = "Mods: %s",
	guest = "Guest",
}

localization.textMultiplayer = {
	title = "Multiplayer and players",
	noPlayers = "Nobody is online.",
	players = "Players:",
	createTip = "Create your own room:",
	createRoom = "Create a room",
	name = "Name",
	password = "Password",
	create = "Create",
	enterPassword = "Enter password to join the %s",
	back = "Back",
	notConnected = "Trying to connect.\nStatus: %s",
}

localization.textMultiplayerScreen = {
	roomName = "Room name: %s",
	playerCount = "Players: %i",
}

localization.textChartInfo = {
	chartInfo = "Chart info",
	artist = "Artist",
	title = "Title",
	chartName = "Name",
	bpm = "BPM",
	tags = "Tags",
	source = "Source",
	chartFormat = "Format",
	setName = "Set name",
	path = "Path",
	audioPath = "Audio path",
	backgroundPath = "Background path",
	mode = "Mode",
	chartFileName = "Chart file name",
	hash = "MD5 hash",
}

localization.textMainMenu = {
	morning = "Good morning!",
	day = "Good day!",
	evening = "Good evening!",
	night = "Good night!",
	modifiers = "Modifiers",
	filters = "Filters",
	noteSkins = "Note skins",
	inputs = "Inputs",
	keyBinds = "Key binds",
	multiplayer = "Multiplayer",
	chartEditor = "Chart editor",
	retry = "Retry",
	watch = "Watch",
	submit = "Submit",
}

localization.textKeybinds = {
	keybinds = "Key binds",
}

localization.textNotification = {
	volume = "Volume: %i%%",
	chartStarted = "%s - %s [%s]\nLength: %s",
}

localization.keybindsGlobal = {
	insertMode = "Insert mode",
	normalMode = "Normal mode",
	quit = "Close a window or quit from a screen",
	showChartInfo = "Show all information about the selected chart",
	showKeybinds = "Show keybind table (You are here)",
	increaseVolume = "Increase volume",
	decreaseVolume = "Decrease volume",
}

localization.keybindsLargeList = {
	up = "Move up in the list",
	down = "Move down in the list",
	up10 = "Move up 10 items in the list",
	down10 = "Move down 10 items in the list",
	toStart = "Move to the start of the list",
	toEnd = "Move to the end of the list",
}

localization.keybindsSmallList = {
	up = "Move up in the small list",
	down = "Move down in the small list",
}

localization.keybindsSongSelect = {
	play = "Play the selected chart",
	showMods = "Show chart modifiers",
	random = "Pick a random chart",
	decreaseTimeRate = "Decrease the music time rate",
	increaseTimeRate = "Increase the music time rate",
	undoRandom = "Undo the random chart selection",
	clearSearch = "Clear the search field",
	moveScreenLeft = "Move the screen to the left",
	moveScreenRight = "Move the screen to the right",
	pauseMusic = "Pause the music",
	showSkins = "Show available skins",
	showFilters = "Show chart and score filters",
	showInputs = "Show input settings",
	showMultiplayer = "Show multiplayer window or return to lobby",
	showKeybinds = "Show keybinds window",
	autoPlay = "Start chart in auto-play mode",
	openEditor = "Open the chart editor",
	openResult = "Open the result screen",
}

localization.keybindsResult = {
	watchReplay = "Watch the replay",
	retry = "Retry the chart",
	submitScore = "(Re)submit your score",
}

localization.fontFamilyList = {
	["ZenMaruGothic-Black"] = {
		"irizz/fonts/ZenMaruGothic/ZenMaruGothic-Black.ttf",
	},
	["ZenMaruGothic-Medium"] = {
		"irizz/fonts/ZenMaruGothic/ZenMaruGothic-Medium.ttf",
	},
	["Titillium-Web-Regular"] = {
		"irizz/fonts/Titillium_Web/TitilliumWeb-Regular.ttf",
	},
	["Titillium-Web-SemiBold"] = {
		"irizz/fonts/Titillium_Web/TitilliumWeb-SemiBold.ttf",
	},
	["Titillium-Web-Bold"] = {
		"irizz/fonts/Titillium_Web/TitilliumWeb-Bold.ttf",
	},
}

localization.fonts = {
	header = {
		anyText = { "ZenMaruGothic-Black", 24 },
	},

	settingsViewConfig = {
		tabs = { "ZenMaruGothic-Medium", 28 },
	},

	songSelectViewConfig = {
		searchField = { "ZenMaruGothic-Black", 36 },
		filterLine = { "ZenMaruGothic-Black", 24 },
		difficulty = { "ZenMaruGothic-Medium", 28 },
		calculator = { "ZenMaruGothic-Medium", 24 },
		patterns = { "ZenMaruGothic-Medium", 22 },
		info = { "ZenMaruGothic-Medium", 28 },
		moreInfo = { "ZenMaruGothic-Medium", 28 },
		timeRate = { "ZenMaruGothic-Medium", 32 },
		mods = { "ZenMaruGothic-Medium", 24 },
		titleAndDifficulty = { "ZenMaruGothic-Black", 32 },
	},

	collectionsViewConfig = {
		searchField = { "ZenMaruGothic-Black", 36 },
		queue = { "ZenMaruGothic-Medium", 32 },
		osuDirectCharts = { "ZenMaruGothic-Medium", 32 },
		buttons = { "ZenMaruGothic-Medium", 28 },
		titleAndMode = { "ZenMaruGothic-Black", 32 },
	},

	noteChartListView = {
		inputMode = { "ZenMaruGothic-Black", 18 },
		difficulty = { "ZenMaruGothic-Black", 24 },
		creator = { "ZenMaruGothic-Black", 18 },
		name = { "ZenMaruGothic-Black", 24 },
		noItems = { "ZenMaruGothic-Medium", 36 },
	},

	noteChartSetListView = {
		artist = { "ZenMaruGothic-Black", 18 },
		title = { "ZenMaruGothic-Black", 24 },
		noItems = { "ZenMaruGothic-Medium", 36 },
	},

	collectionsListView = {
		itemCount = { "ZenMaruGothic-Black", 18 },
		name = { "ZenMaruGothic-Black", 24 },
		noItems = { "ZenMaruGothic-Medium", 36 },
	},

	scoreListView = {
		line1 = { "ZenMaruGothic-Black", 20 },
		line2 = { "ZenMaruGothic-Black", 18 },
		noItems = { "ZenMaruGothic-Medium", 36 },
	},

	osuDirectListView = {
		artist = { "ZenMaruGothic-Black", 18 },
		title = { "ZenMaruGothic-Black", 24 },
		noItems = { "ZenMaruGothic-Medium", 36 },
	},

	osuDirectChartsListView = {
		creator = { "ZenMaruGothic-Black", 18 },
		difficultyName = { "ZenMaruGothic-Black", 24 },
		noItems = { "ZenMaruGothic-Medium", 36 },
	},

	osuDirectQueueListView = {
		title = { "ZenMaruGothic-Black", 24 },
		artist = { "ZenMaruGothic-Black", 14 },
		status = { "ZenMaruGothic-Black", 14 },
		noItems = { "ZenMaruGothic-Medium", 36 },
	},

	modifiersModal = {
		title = { "ZenMaruGothic-Black", 72 },
		modifierName = { "ZenMaruGothic-Black", 24 },
		inputMode = { "ZenMaruGothic-Black", 48 },
		numberOfUses = { "ZenMaruGothic-Black", 24 },
		noItems = { "ZenMaruGothic-Medium", 36 },
	},

	noteSkinModal = {
		title = { "ZenMaruGothic-Black", 72 },
		skinName = { "ZenMaruGothic-Black", 48 },
		noteSkinName = { "ZenMaruGothic-Black", 24 },
		noteSkinSettings = { "ZenMaruGothic-Black", 24 },
		noSettings = { "ZenMaruGothic-Medium", 36 },
		noItems = { "ZenMaruGothic-Medium", 36 },
	},

	inputsModal = {
		title = { "ZenMaruGothic-Black", 72 },
		tabs = { "ZenMaruGothic-Medium", 28 },
		noInputs = { "ZenMaruGothic-Medium", 36 },
		inputs = { "ZenMaruGothic-Black", 24 },
		inputMode = { "ZenMaruGothic-Black", 48 },
		noItems = { "ZenMaruGothic-Medium", 36 },
	},

	mountsModal = {
		title = { "ZenMaruGothic-Black", 72 },
		tabs = { "ZenMaruGothic-Medium", 28 },
		noItems = { "ZenMaruGothic-Medium", 36 },
		textHeader = { "ZenMaruGothic-Medium", 28 },
		mountPaths = { "ZenMaruGothic-Black", 24 },
		windowText = { "ZenMaruGothic-Medium", 24 },
		fields = { "ZenMaruGothic-Medium", 28 },
		path = { "ZenMaruGothic-Black", 48 },
		status = { "ZenMaruGothic-Medium", 36 },
		buttons = { "ZenMaruGothic-Medium", 28 },
	},

	onlineModal = {
		status = { "ZenMaruGothic-Black", 48 },
		fields = { "ZenMaruGothic-Medium", 36 },
		buttons = { "ZenMaruGothic-Medium", 28 },
	},

	filtersModal = {
		title = { "ZenMaruGothic-Black", 72 },
		checkboxes = { "ZenMaruGothic-Black", 24 },
		headerText = { "ZenMaruGothic-Black", 28 },
		filtersLine = { "ZenMaruGothic-Black", 48 },
	},

	multiplayerModal = {
		title = { "ZenMaruGothic-Black", 72 },
		listHeader = { "ZenMaruGothic-Black", 32 },
		lists = { "ZenMaruGothic-Black", 24 },
		buttons = { "ZenMaruGothic-Black", 28 },
		noItems = { "ZenMaruGothic-Medium", 36 },
	},

	resultView = {
		titleAndDifficulty = { "ZenMaruGothic-Black", 32 },
		modifiers = { "Titillium-Web-Bold", 28 },
		accuracy = { "Titillium-Web-Bold", 28 },
		counterName = { "Titillium-Web-SemiBold", 24 },
		grade = { "Titillium-Web-Regular", 24 },
		timings = { "Titillium-Web-Regular", 24 },
		difficultyValue = { "Titillium-Web-SemiBold", 32 },
		calculator = { "Titillium-Web-Regular", 24 },
		patterns = { "Titillium-Web-Regular", 24 },
		timeRate = { "Titillium-Web-SemiBold", 32 },
		scoreInfo = { "Titillium-Web-Regular", 24 },
	},

	osuResultView = {
		title = { "ZenMaruGothic-Black", 36 },
		creator = { "Titillium-Web-Regular", 24 },
		playInfo = { "Titillium-Web-Regular", 24 },
		accuracy = { "Titillium-Web-Regular", 20 },
		graphInfo = { "Titillium-Web-Regular", 18 },
		pp = { "Titillium-Web-SemiBold", 36 },
	},

	multiplayerView = {
		titleAndDifficulty = { "ZenMaruGothic-Black", 32 },
		roomInfo = { "ZenMaruGothic-Black", 24 },
	},

	keybindsModal = {
		title = { "ZenMaruGothic-Black", 72 },
		keybinds = { "ZenMaruGothic-Black", 24 },
	},

	chartInfoModal = {
		title = { "ZenMaruGothic-Black", 72 },
		info = { "ZenMaruGothic-Medium", 24 },
	},

	notifications = {
		message = { "ZenMaruGothic-Medium", 36 },
		smallText = { "ZenMaruGothic-Medium", 24 },
	},

	mainMenuView = {
		title = { "ZenMaruGothic-Medium", 72 },
		timeOfDay = { "ZenMaruGothic-Medium", 48 },
		buttons = { "ZenMaruGothic-Medium", 24 },
	},
}

return localization
