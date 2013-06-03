//
//  ITTDebug.h
//
//  Modified from Three20 Debugging tools by lian jie on 5/31/10.

/**
 * Modified from Three20 Debugging tools.
 *
 * Provided in this header are a set of debugging tools. This is meant quite literally, in that
 * all of the macros below will only function when the DEBUG preprocessor macro is specified.
 *
 * TTDASSERT(<statement>);
 * If <statement> is false, the statement will be written to the log and if you are running in
 * the simulator with a debugger attached, the app will break on the assertion line.
 *
 * TTDPRINT(@"formatted log text %d", param1);
 * Print the given formatted text to the log.
 *
 * TTDPRINTMETHODNAME();
 * Print the current method to the log.
 *
 * TTDCONDITIONLOG(<statement>, @"formatted log text %d", param1);
 * Only if <statement> is true then the formatted text will be written to the log.
 *
 * TTDINFO/TTDWARNING/TTDERROR(@"formatted log text %d", param1);
 * Will only write the formatted text to the log if TTMAXLOGLEVEL is greater than the respective
 * TTD* method's log level. See below for log levels.
 *
 * The default maximum log level is TTLOGLEVEL_WARNING.
 */
#define ITTDEBUG
#define ITTLOGLEVEL_INFO     10
#define ITTLOGLEVEL_WARNING  3
#define ITTLOGLEVEL_ERROR    1

#ifndef ITTMAXLOGLEVEL

#ifdef DEBUG
    #define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO
#else
    #define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR
#endif

#endif

// The general purpose logger. This ignores logging levels.
#ifdef ITTDEBUG
  #define ITTDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
  #define ITTDPRINT(xx, ...)  ((void)0)
#endif

// Prints the current method's name.
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
  #define ITTDERROR(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
  #define ITTDERROR(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
  #define ITTDWARNING(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
  #define ITTDWARNING(xx, ...)  ((void)0)
#endif

#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
  #define ITTDINFO(xx, ...)  ITTDPRINT(xx, ##__VA_ARGS__)
#else
  #define ITTDINFO(xx, ...)  ((void)0)
#endif

#ifdef ITTDEBUG
  #define ITTDCONDITIONLOG(condition, xx, ...) { if ((condition)) { \
                                                  ITTDPRINT(xx, ##__VA_ARGS__); \
                                                } \
                                              } ((void)0)
#else
  #define ITTDCONDITIONLOG(condition, xx, ...) ((void)0)
#endif


#define ITTAssert(condition, ...)                                       \
do {                                                                      \
    if (!(condition)) {                                                     \
        [[NSAssertionHandler currentHandler]                                  \
            handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
                                file:[NSString stringWithUTF8String:__FILE__]  \
                            lineNumber:__LINE__                                  \
                            description:__VA_ARGS__];                             \
    }                                                                       \
} while(0)
