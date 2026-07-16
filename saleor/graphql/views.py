import json
from graphene_django.views import GraphQLView

__author__ = 'tkolter'

from django.contrib.auth.mixins import AccessMixin, LoginRequiredMixin
from django.http.response import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from graphene_django.views import GraphQLView
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.exceptions import InvalidToken
from rest_framework_simplejwt.settings import api_settings

jwt_auth = JWTAuthentication()

class JWTAuthMixin(AccessMixin):
    @csrf_exempt
    def dispatch(self, request, *args, **kwargs):
        try:
            authentication = jwt_auth.authenticate(request)

            if not authentication:
                return super(AccessMixin, self).dispatch(request, *args, **kwargs)

            request.user, request.token = authentication
        except Exception as e:
            response = HttpResponse(
                json.dumps({'errors': [str(e)]}),
                status=401,
                content_type='application/json'
            )

            response['WWW-Authenticate'] = self.authenticate_header(request)

        return super(JWTAuthMixin, self).dispatch(request, *args, **kwargs)

class PrivateGraphQLView(JWTAuthMixin, GraphQLView):
    pass
