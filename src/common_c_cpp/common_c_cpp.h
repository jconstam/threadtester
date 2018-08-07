#include <time.h>

typedef struct PARAMS_STRUCT
{
	int count;
	int start;
} PARAMS;

#define DO_START		( 0 )
#define DO_END			( 1 )

#define THREAD_MIN_ALIVE_TIME_US	( 1000U )

#ifdef __cplusplus
extern "C"
{
#endif
	float GetMicroDiff( struct timespec*, struct timespec* );
	void GetTime( struct timespec* );
	PARAMS getParams( int, char* const[ ] );
#ifdef __cplusplus
}
#endif