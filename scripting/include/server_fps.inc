native float GetServerFPS();

/**
 * Do not edit below this line!
 */
public Extension __ext_server_fps = 
{
	name = "Server FPS",
	file = "server_fps.ext",
#if defined AUTOLOAD_EXTENSIONS
	autoload = 1,
#else
	autoload = 0,
#endif
#if defined REQUIRE_EXTENSIONS
	required = 1,
#else
	required = 0,
#endif
};