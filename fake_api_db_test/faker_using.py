from faker import Faker
from robot.api.deco import keyword

fake = Faker()


@keyword("GET FAKE IMAGE URL")
def get_fake_image_url():
    return fake.image_url()


@keyword("GET FAKE NAME")
def get_fake_name():
    return fake.name()

