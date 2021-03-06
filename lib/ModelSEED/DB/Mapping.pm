package ModelSEED::DB::Mapping;


use strict;
use Data::UUID;

use base qw(ModelSEED::DB::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'mappings',

    columns => [
        uuid              => { type => 'character', length => 36, not_null => 1 },
        modDate           => { type => 'datetime' },
        locked            => { type => 'integer' },
        public            => { type => 'integer' },
        name              => { type => 'varchar', length => 255 },
        biochemistry_uuid => { type => 'character', length => 36, not_null => 1 },
    ],

    primary_key_columns => [ 'uuid' ],

    foreign_keys => [
        biochemistry => {
            class       => 'ModelSEED::DB::Biochemistry',
            key_columns => { biochemistry_uuid => 'uuid' },
        },
    ],

    relationships => [
        children => {
            map_class => 'ModelSEED::DB::MappingParent',
            map_from  => 'parent',
            map_to    => 'child',
            type      => 'many to many',
        },

        complexes => {
            map_class => 'ModelSEED::DB::MappingComplex',
            map_from  => 'mapping',
            map_to    => 'complex',
            type      => 'many to many',
        },

        reaction_rules => {
            map_class => 'ModelSEED::DB::MappingReactionRule',
            map_from  => 'mapping',
            map_to    => 'reaction_rule',
            type      => 'many to many',
        },

        mapping_aliases => {
            class      => 'ModelSEED::DB::MappingAlias',
            column_map => { uuid => 'mapping_uuid' },
            type       => 'one to many',
        },

        models => {
            class      => 'ModelSEED::DB::Model',
            column_map => { uuid => 'mapping_uuid' },
            type       => 'one to many',
        },

        parents => {
            map_class => 'ModelSEED::DB::MappingParent',
            map_from  => 'child',
            map_to    => 'parent',
            type      => 'many to many',
        },

        roles => {
            map_class => 'ModelSEED::DB::MappingRole',
            map_from  => 'mapping',
            map_to    => 'role',
            type      => 'many to many',
        },
    ],
);



__PACKAGE__->meta->column('uuid')->add_trigger(
    deflate => sub {
        my $uuid = $_[0]->uuid;
        if(ref($uuid) && ref($uuid) eq 'Data::UUID') {
            return $uuid->to_string();
        } elsif($uuid) {
            return $uuid;
        } else {
            return Data::UUID->new()->create_str();
        }
});


1;
