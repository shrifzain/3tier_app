from django.db import OperationalError, ProgrammingError
from django.db.utils import DatabaseError
from rest_framework.decorators import api_view
from myapp.serializers import UserSerializer
from rest_framework.response import Response
from myapp.models import User

@api_view(['GET'])
def Allusers(request):
    try:
        if request.method == 'GET':
            users = User.objects.all()
            serializer = UserSerializer(users, many=True)
            return Response(serializer.data)
    except DatabaseError as e:
        return Response({'error': 'Server encountered a database error.'}, status=500)
    except OperationalError as e:
        return Response({'error': 'Server could not connect to the database.'}, status=500)
    except ProgrammingError as e:
        return Response({'error': 'Server encountered a programming error with the database.'}, status=500)

