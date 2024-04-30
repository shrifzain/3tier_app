from django.db import models
class User(models.Model):
    user = models.CharField(max_length=100)
    def __str__(self):
        return self.name

# Create your models here.
