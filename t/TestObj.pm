package t::TestObj;

use strict;

use base qw( Tangence::Object );

use Tangence::Constants;

our %PROPS = (
   scalar => {
      dim  => DIM_SCALAR,
      type => 'int',
   },

   hash => {
      dim  => DIM_HASH,
      type => 'int',
   },

   queue => {
      dim  => DIM_QUEUE,
      type => 'int',
   },

   array => {
      dim  => DIM_ARRAY,
      type => 'int',
   },
);

sub new
{
   my $class = shift;

   my $self = $class->SUPER::new( @_ );


   return $self;
}

sub init_prop_scalar { 123 }
sub init_prop_hash   { { one => 1, two => 2, three => 3 } }
sub init_prop_queue  { [ 1, 2, 3 ] }
sub init_prop_array  { [ 1, 2, 3 ] }

sub add_number
{
   my $self = shift;
   my ( $name, $num ) = @_;

   if( index( my $scalar = $self->get_prop_scalar, $num ) == -1 ) {
      $scalar .= $num;
      $self->set_prop_scalar( $scalar );
   }

   $self->add_prop_hash( $name, $num );

   if( !grep { $_ == $num } @{ $self->get_prop_array } ) {
      $self->push_prop_array( $num );
   }
}

sub del_number
{
   my $self = shift;
   my ( $num ) = @_;

   my $hash = $self->get_prop_hash;
   my $name;
   $hash->{$_} == $num and ( $name = $_, last ) for keys %$hash;

   defined $name or die "No name for $num";

   if( index( ( my $scalar = $self->get_prop_scalar ), $num ) != -1 ) {
      $scalar =~ s/\Q$num//;
      $self->set_prop_scalar( $scalar );
   }

   $self->del_prop_hash( $name );

   my $array = $self->get_prop_array;
   if( grep { $_ == $num } @$array ) {
      my $index;
      $array->[$_] == $num and ( $index = $_, last ) for 0 .. $#$array;
      $index == 0 ? $self->shift_prop_array() : $self->splice_prop_array( $index, 1, () );
   }
}

1;