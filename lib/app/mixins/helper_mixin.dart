import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

mixin HelperMixin {
  static int getTimestamp() {
    return (DateTime.now().millisecondsSinceEpoch / 1000).round();
  }

  static double getBodyHeight(context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
  }

  static bool isDirectionRTL(BuildContext context) {
    return intl.Bidi.isRtlLanguage(
        Localizations.localeOf(context).languageCode);
  }

  ///
  /// Return different time between given datetime and now
  /// Cardinality for days
  ///
  static get timeAgo => (DateTime datetime) {
        tz.initializeTimeZones();
        final pacificTimeZone = tz.getLocation('Asia/Beirut');

        datetime = tz.TZDateTime.from(datetime, pacificTimeZone);
        log('Time testing: ${DateTime.now().timeZoneName}, ${DateTime.now().hour}: ${DateTime.now().minute}');
        Duration diff = DateTime.now().difference(datetime);
        final years = (diff.inDays / 365).floor();
        final months = (diff.inDays % 365 / 30).floor();
        final days = diff.inDays % 365 % 30;

        var msg = '';
        log('timeAgo : ${datetime.toString()},${diff.inDays}');
        if (diff.inDays >= 1) {
          if (years >= 1) {
            msg += '$years ${Intl.plural(years, one: 'year', other: 'years')}';
            msg += ' ';
          }
          if (months >= 1) {
            msg +=
                '$months ${Intl.plural(months, one: 'month', other: 'months')}';
            msg += ' ';
          }
          if (days >= 1) {
            msg += '$days ${Intl.plural(days, one: 'day', other: 'days')}';
            msg += ' ';
          }
        } else if (diff.inHours >= 1) {
          msg =
              '${diff.inHours} ${Intl.plural(diff.inHours, one: 'hour', other: 'hours')}';
        } else if (diff.inMinutes >= 1) {
          msg =
              '${diff.inMinutes} ${Intl.plural(diff.inMinutes, one: 'minute', other: 'minutes')}';
        } else {
          msg = 'Now';
        }

        return msg;
      };

  ///
  /// Return different time between given datetime and now
  /// Cardinality for hours
  ///
  get differentTime => (DateTime date) {
        Duration diff = DateTime.now().difference(date);
        final years = (diff.inHours / (365 * 24)).floor();
        final months = ((diff.inHours % (365 * 24)) / (30 * 24)).floor();
        final days = (((diff.inHours % (365 * 24)) % (30 * 24)) / 24).floor();
        final hours = (((diff.inHours % (365 * 24)) % (30 * 24)) % 24);
        var msg = '';

        if (diff.inHours >= 1) {
          if (years >= 1) {
            msg += '$years ${Intl.plural(years, one: 'year', other: 'years')}';
            msg += ' ';
          }
          if (months >= 1) {
            msg +=
                '$months ${Intl.plural(months, one: 'month', other: 'months')}';
            msg += ' ';
          }
          if (days >= 1) {
            msg += '$days ${Intl.plural(days, one: 'day', other: 'days')}';
            msg += ' ';
          }
          if (hours >= 1) {
            msg += '$hours ${Intl.plural(hours, one: 'hour', other: 'hours')}';
            msg += ' ';
          }
        } else if (diff.inMinutes >= 1) {
          msg =
              '${diff.inMinutes} ${Intl.plural(diff.inMinutes, one: 'minute', other: 'minutes')}';
        } else {
          msg = 'Now';
        }

        return msg;
      };

  ///
  ///when failed Return given argument
  ///
  static dynamic tryJsonDecode(data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      return data;
    }
  }
}
