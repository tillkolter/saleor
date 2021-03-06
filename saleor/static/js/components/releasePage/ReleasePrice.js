import React, { PropTypes } from 'react';
import Relay from 'react-relay';

import SaleImg from '../../../images/sale_bg.svg';

const ReleasePrice = ({ availability, price }) => {
  const { discount, priceRange } = availability;
  const isPriceRange = priceRange && priceRange.minPrice.gross !== priceRange.maxPrice.gross;
  return (
    <div>
      <span itemProp="price">
        {isPriceRange && <span>{gettext('from')} </span>} {priceRange.minPrice.grossLocalized}
      </span>
      {discount && (
        <div className="product-list__sale"><img src={SaleImg}/><span>{gettext('Sale')}</span></div>
      )}
      <div className={'product__info__availability ' + availability.status}></div>
    </div>
  );
};

ReleasePrice.propTypes = {
  availability: PropTypes.object.isRequired,
  price: PropTypes.object.isRequired
};

export default Relay.createContainer(ReleasePrice, {
  fragments: {
    availability: () => Relay.QL`
      fragment on ProductAvailabilityType {
        status
        priceRange  {
          maxPrice { gross, grossLocalized, currency },
          minPrice { gross, grossLocalized, currency }
        }
      }
    `
  }
});
