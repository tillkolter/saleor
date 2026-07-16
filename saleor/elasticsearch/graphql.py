import graphene
from graphene.types.json import JSONString
from saleor.elasticsearch.search import OYE_ARTISTS_INDEX, OYE_LABELS_INDEX, OYE_RELEASES_INDEX
from saleor_oye.graphql.charts import ArtistType
from saleor_oye.graphql.labels import LabelType
from saleor_oye.graphql.releases import ArtikelType
from saleor_oye.models import Artikel, Artist, Label

__author__ = 'tkolter'


class SearchableType(graphene.Interface):
    score = graphene.Float()

    @classmethod
    def resolve_type(cls, instance, info):
        index = instance.hit.index
        if index == OYE_RELEASES_INDEX:
            return ReleaseSearchResult
        if index == OYE_ARTISTS_INDEX:
            return ArtistSearchResult
        if index == OYE_LABELS_INDEX:
            return LabelSearchResult


    def resolve_score(self, info):
        return self.hit.meta.score

class ReleaseSearchResult(graphene.ObjectType):
    class Meta:
        interfaces = (SearchableType, )

    release = graphene.Field(lambda: ArtikelType)

    def resolve_release(self, info):
        return self.instance


class ArtistSearchResult(graphene.ObjectType):
    class Meta:
        interfaces = (SearchableType, )

    artist = graphene.Field(lambda: ArtistType)

    def resolve_artist(self, info):
        return self.instance


class LabelSearchResult(graphene.ObjectType):
    class Meta:
        interfaces = (SearchableType, )

    label = graphene.Field(lambda: LabelType)

    def resolve_label(self, info):
        return self.instance


class SearchResult(graphene.ObjectType):

    total = graphene.Int()

    results = graphene.List(lambda: SearchableType)
