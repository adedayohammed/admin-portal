"""URL configuration for admin project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/

Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))

"""

from django.conf import settings

# from django.conf.urls import handler400, handler404, handler500
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import include, path
from drf_spectacular.views import (
    SpectacularAPIView,
    SpectacularRedocView,
    SpectacularSwaggerView,
)

from api_errors.error_types import custom_400_view, custom_404_view, custom_500_view

urlpatterns = [
    path("grappelli/", include("grappelli.urls")),
    path("avetium/secret-admin-001/", admin.site.urls),
    path("api/health/", include("health.urls", namespace="health")),
    # path("api/<str:version>/auth/", include("accounts.urls", namespace="accounts")),
    # path("api/<str:version>/partners/", include("clients.urls", namespace="clients")),
    path("api/<str:version>/me/", include("users.urls", namespace="users")),
    path("api/<str:version>/org/", include("organizations.urls", namespace="organizations")),
    # path("api/<str:version>/submit/", include("submissions.urls", namespace="submissions")),
    # Schema endpoint
    path("api/<str:version>/schema/", SpectacularAPIView.as_view(), name="schema"),
    # Optional Swagger UI
    path(
        "api/<str:version>/schema/swagger-ui/",
        SpectacularSwaggerView.as_view(url_name="schema"),
        name="swagger-ui",
    ),
    # Optional Redoc UI
    path(
        "api/<str:version>/schema/redoc/",
        SpectacularRedocView.as_view(url_name="schema"),
        name="redoc",
    ),
]

urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

# Custom api errors
handler400 = custom_400_view
handler404 = custom_404_view
handler500 = custom_500_view