/*
 * Copyright 2022 Nikita Ivanov
 *
 * This file is part of ictree
 *
 * ictree is free software: you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * ictree is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * ictree. If not, see <https://www.gnu.org/licenses/>.
 */

#include <stdarg.h>
#include <stdio.h>
#include <string.h>

#include "error.h"
#include "utils.h"

static char error_buf[ERROR_BUF_SIZE];

void set_error(char *buf)
{
    strncpy(error_buf, buf, ERROR_BUF_SIZE);
}

void set_errorf(char *format, ...)
{
    char msg[ERROR_BUF_SIZE];
    FORMATTED_STRING(msg, format);
    set_error(msg);
}

char *get_error()
{
    return error_buf;
}
