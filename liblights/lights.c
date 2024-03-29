/*
 * Copyright (C) 2012 The Android Open Source Project
 *                    The CyanogenMod Project
 *                    Daniel Hillenbrand <codeworkx@cyanogenmod.com>
 *                    Tanguy Pruvot <tpruvot@github>
 *                    Adam77Root <Adam77Root@github>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#define LOG_TAG "lights"
//#define LOG_NDEBUG 0

#include <cutils/log.h>

#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>

#include <sys/ioctl.h>
#include <sys/types.h>

#include <hardware/lights.h>

/******************************************************************************/

/* LED NOTIFICATIONS BACKLIGHT */
#define ENABLE_BL		1
#define DISABLE_BL		0

static pthread_once_t g_init = PTHREAD_ONCE_INIT;
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;

char const*const PANEL_FILE = "/sys/class/backlight/pwm-backlight/brightness";
#if defined (I9103)
char const*const BUTTON_FILE = "/sys/class/leds/button-backlight/brightness"; // For Galaxy R
#else if defined (I927)
char const*const BUTTON_FILE = "/sys/class/misc/melfas_touchkey/brightness"; // For Captivate Glide
char const*const KEYBOARD_FILE = "/sys/class/sec/sec_stmpe_bl/backlight";
#endif
char const*const NOTIFICATION_FILE_BLN = "/sys/class/misc/backlightnotification/notification_led";

void init_g_lock(void)
{
    pthread_mutex_init(&g_lock, NULL);
}

static int write_int(char const *path, int value)
{
    int fd;
    static int already_warned;

    already_warned = 0;

    fd = open(path, O_RDWR);
    if (fd >= 0) {
        char buffer[20];
        int bytes = sprintf(buffer, "%d\n", value);
        int amt = write(fd, buffer, bytes);
        close(fd);
        return amt == -1 ? -errno : 0;
    } else {
        if (already_warned == 0) {
            ALOGE("write_int failed to open %s, %s\n", path, strerror(errno));
            already_warned = 1;
        }
        return -errno;
    }
}

#if defined (I927)
static int is_lit(struct light_state_t const* state)
{
    return state->color & 0x00ffffff;
}
#endif

static int rgb_to_brightness(struct light_state_t const *state)
{
    int color = state->color & 0x00ffffff;

    return ((77*((color>>16) & 0x00ff))
        + (150*((color>>8) & 0x00ff)) + (29*(color & 0x00ff))) >> 8;
}

static int set_light_backlight(struct light_device_t *dev,
            struct light_state_t const *state)
{
    int err = 0;
    int brightness = rgb_to_brightness(state);

    pthread_mutex_lock(&g_lock);
    ALOGV("%s(%d)", __FUNCTION__, brightness);
    err = write_int(PANEL_FILE, brightness);
    pthread_mutex_unlock(&g_lock);

    return err;
}

static int set_light_buttons(struct light_device_t *dev,
            struct light_state_t const *state)
{
    int err = 0;
    int brightness = rgb_to_brightness(state);
    /* Hack for stock Samsung roms */
    if(brightness != 0)
	brightness = 255;

    pthread_mutex_lock(&g_lock);
    ALOGV("%s(%d)", __FUNCTION__, brightness);
    err = write_int(BUTTON_FILE, brightness);
    pthread_mutex_unlock(&g_lock);

    return err;
}

#if defined (I927)
static int set_light_keyboard(struct light_device_t* dev,
        struct light_state_t const* state)
{
    int err = 0;
    int on = is_lit (state);

    pthread_mutex_lock(&g_lock);
    ALOGV("%s(%d)", __FUNCTION__, on);
    err = write_int(KEYBOARD_FILE, on ? 1 : 0);
    pthread_mutex_unlock(&g_lock);

    return err;
}
#endif

static int close_lights(struct light_device_t *dev)
{
    ALOGV("%s", __FUNCTION__);
    if (dev)
        free(dev);

    return 0;
}

/* LED functions */
static int set_light_leds_notifications(struct light_device_t *dev,
            struct light_state_t const *state)
{
    int err = 0;
    int brightness = rgb_to_brightness(state);
        
    if (brightness+state->color == 0 || brightness > 100 ) {
    	pthread_mutex_lock(&g_lock);

    	if (state->color & 0x00ffffff) {
    		ALOGV("[LED Notify] set_light_leds_notifications - ENABLE_BL\n");
            	err = write_int (NOTIFICATION_FILE_BLN, ENABLE_BL);
    	} else {
    		ALOGV("[LED Notify] set_light_leds_notifications - DISABLE_BL\n");
    		err = write_int (NOTIFICATION_FILE_BLN, DISABLE_BL);
    	}
        pthread_mutex_unlock(&g_lock);
    }

    return 0;
}

static int set_light_leds_attention(struct light_device_t *dev,
            struct light_state_t const *state)
{
    return 0;
}

static int set_light_battery(struct light_device_t *dev,
            struct light_state_t const *state)
{
    return 0;
}

static int open_lights(const struct hw_module_t *module, char const *name,
                        struct hw_device_t **device)
{
    int (*set_light)(struct light_device_t *dev,
        struct light_state_t const *state);

    if (0 == strcmp(LIGHT_ID_BACKLIGHT, name))
        set_light = set_light_backlight;
    else if (0 == strcmp(LIGHT_ID_BUTTONS, name))
        set_light = set_light_buttons;
    else if (0 == strcmp(LIGHT_ID_NOTIFICATIONS, name))
        set_light = set_light_leds_notifications;
    else if (0 == strcmp(LIGHT_ID_ATTENTION, name))
        set_light = set_light_leds_attention;
    else if (0 == strcmp(LIGHT_ID_BATTERY, name))
        set_light = set_light_battery;
#if defined (I927)
    else if (0 == strcmp(LIGHT_ID_KEYBOARD, name))
        set_light = set_light_keyboard;
#endif
    else
        return -EINVAL;

    pthread_once(&g_init, init_g_lock);

    struct light_device_t *dev = malloc(sizeof(struct light_device_t));
    memset(dev, 0, sizeof(*dev));

    dev->common.tag = HARDWARE_DEVICE_TAG;
    dev->common.version = 0;
    dev->common.module = (struct hw_module_t *)module;
    dev->common.close = (int (*)(struct hw_device_t *))close_lights;
    dev->set_light = set_light;

    *device = (struct hw_device_t *)dev;

    return 0;
}

static struct hw_module_methods_t lights_module_methods = {
    .open =  open_lights,
};

struct hw_module_t HAL_MODULE_INFO_SYM = {
    .tag = HARDWARE_MODULE_TAG,
    .version_major = 1,
    .version_minor = 0,
    .id = LIGHTS_HARDWARE_MODULE_ID,
    .name = "Tegra lights Module",
    .author = "The CyanogenMod Project",
    .methods = &lights_module_methods,
};
