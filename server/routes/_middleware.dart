// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

// lib/_middleware.dart

import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/authenticator.dart';
import 'package:smartopia_hms_server/logger.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;


Handler middleware(Handler handler) {
  // create one Authenticator for all requests
  final auth = Authenticator();

  Handler logRequests(Handler inner) {
    return (context) async {
      final req = context.request;
      logInfo('→ ${req.method.name} ${req.uri}');
      try {
        final res = await inner(context);
        logInfo('← ${res.statusCode} ${req.method.name} ${req.uri}');
        return res;
      } catch (err, st) {
        logError(
          '✖ ${req.method.name} ${req.uri} threw $err',
          err,
          st,
        );
        return Response(
          statusCode: 500,
          body: 'Internal Server Error',
          headers: {
            'Content-Type': 'text/plain',
          },
        );
        //rethrow; // let Dart Frog return a 500 or your own error handler run
      }
    };
  }

  Handler authRequest(Handler inner) {
    return (ctx) async {
      final req = ctx.request;

      // Need to handle CORS preflight requests manually for some unknown reason
      if (req.method == HttpMethod.options) {
        return Response(
          statusCode: 204, // no content
          headers: {
            'Access-Control-Allow-Origin': '*',                    // or your origin
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            'Access-Control-Max-Age': '86400',                     // cache for 1 day
          },
        );
      }

      const publicPaths = [
              '/api/signup',
              '/api/signin',
              '/api/notifications', // SSE endpoint
              '/index.html', // static file
              '/api/hello', // test endpoint
              '/',
              //'/api/tasktemplate',
              //'/api/users',
      ];

      // Allow public access to client downloads
      if (req.uri.path.startsWith('/clients/')) {
        return await inner(ctx);
      }

      if (!req.uri.path.startsWith('/api') && !publicPaths.contains(req.uri.path)) {
        // Redirect any protected GET back to the SPA root
        return Response.movedPermanently(
          location: '/'
        );
      }

      try {
        final authHeader = req.headers['authorization'];        
        final token = authHeader != null && authHeader.toLowerCase().startsWith('bearer ')
          ? authHeader.substring(7).trim()
          : null;
        if (token != null) {
          final user = await auth.verifyToken(token);
          if (user != null) {
            ctx = ctx.provide<User>(() => user);
          } 
        }
        else if (!publicPaths.contains(req.uri.path)) {
          return Response(statusCode: 401, body: 'Unauthorized');
        }
        return await inner(ctx);
      } catch (err, st) {
        logError('middleware.authRequest', err, st);
        //rethrow; // let Dart Frog return a 500 or your own error handler run
        return Response(statusCode: 401, body: 'Unauthorized');
      }
    };
  }


  return handler.use(
    fromShelfMiddleware(
          shelf.corsHeaders(
            headers: {
              shelf.ACCESS_CONTROL_ALLOW_ORIGIN: 'http://localhost:8000',
            },
          ),
        ),
  )
  .use(
    logRequests,
  )
  .use(
    provider<Authenticator>(
      (_) => Authenticator(),
    ),
  )
  .use(authRequest)
  /*.use(
    bearerAuthentication<User>(
          authenticator: (context, token) async {
            // this should verify the JWT signature + expiry, then lookup the user
            //return await auth.verifyToken(token);
            return await auth.verifyToken(token);
          },
          applies: (context) async {
            // this should be a list of paths that require authentication
            // e.g. /api/users, /api/tasks, etc.
            const publicPaths = [
              '/api/signup',
              '/api/signin',
              //'/api/users',
            ];
            if (publicPaths.contains(context.request.uri.path)) {
              return false;
            }
            return true;
          },
        ),
  )*/;
}
