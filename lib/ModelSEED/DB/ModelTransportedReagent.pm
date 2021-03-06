package ModelSEED::DB::ModelTransportedReagent;

use strict;

use base qw(ModelSEED::DB::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'model_transported_reagents',

    columns => [
        model_uuid             => { type => 'character', length => 36, not_null => 1 },
        reaction_uuid          => { type => 'character', length => 36, not_null => 1 },
        compound_uuid          => { type => 'character', length => 36, not_null => 1 },
        transportIndex         => { type => 'integer', not_null => 1 },
        model_compartment_uuid => { type => 'character', length => 36, not_null => 1 },
        transportCoefficient   => { type => 'integer', not_null => 1 },
        isImport               => { type => 'integer' },
    ],

    primary_key_columns => [ 'model_uuid', 'reaction_uuid', 'transportIndex' ],

    foreign_keys => [
        compound => {
            class       => 'ModelSEED::DB::Compound',
            key_columns => { compound_uuid => 'uuid' },
        },

        model => {
            class       => 'ModelSEED::DB::Model',
            key_columns => { model_uuid => 'uuid' },
        },

        model_compartment => {
            class       => 'ModelSEED::DB::ModelCompartment',
            key_columns => { model_compartment_uuid => 'uuid' },
        },

        reaction => {
            class       => 'ModelSEED::DB::Reaction',
            key_columns => { reaction_uuid => 'uuid' },
        },
    ],
);

1;

