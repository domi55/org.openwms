/*
 * openwms.org, the Open Warehouse Management System.
 * Copyright (C) 2014 Heiko Scherrer
 *
 * This file is part of openwms.org.
 *
 * openwms.org is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as 
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * openwms.org is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software. If not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */
package org.openwms.common.integration.jpa;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertNull;
import static junit.framework.Assert.assertTrue;
import static junit.framework.Assert.fail;

import org.junit.Before;
import org.junit.Test;
import org.openwms.common.domain.Location;
import org.openwms.common.domain.LocationGroup;
import org.openwms.common.domain.LocationPK;
import org.openwms.common.integration.LocationDao;
import org.openwms.common.integration.LocationGroupDao;
import org.openwms.core.test.AbstractJpaSpringContextTests;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;

/**
 * A LocationTest.
 * 
 * @author <a href="mailto:scherrer@openwms.org">Heiko Scherrer</a>
 * @version $Revision$
 * @since 0.1
 */
@ContextConfiguration("classpath:common-jpa-test-context.xml")
public class LocationTest extends AbstractJpaSpringContextTests {

    @Autowired
    private LocationDao locationDao;
    @Autowired
    private LocationGroupDao locationGroupDao;

    private final LocationGroup locationGroup = new LocationGroup("TEST_LOCATION_GROUP1");
    private final LocationGroup locationGroup2 = new LocationGroup("TEST_LOCATION_GROUP2");
    private final Location actualLocation = new Location(new LocationPK("NOWN", "NOWN", "NOWN", "NOWN", "NOWN"));
    private final Location virtualLocation = new Location(new LocationPK("VIRT", "VIRT", "VIRT", "VIRT", "VIRT"));

    /**
     * Setup some test data.
     * 
     * @throws Exception
     *             in case of errors
     */
    @Before
    public void onSetUpInTransaction() throws Exception {
        locationGroupDao.persist(locationGroup);
        locationDao.persist(actualLocation);
        locationDao.persist(virtualLocation);
        entityManager.flush();
        entityManager.clear();
    }

    /**
     * Test to assign the LocationGroup to a Location.
     * 
     */
    @Test
    public final void testSettingGroupOnLocation() {
        try {
            locationGroup.addLocation(null);
            fail("Not allowed to add null as location to a group");
        } catch (IllegalArgumentException iae) {
            LOGGER.debug("OK: Exception when trying to add null");
        }

        int noLocations = locationGroup.getLocations().size();

        assertNull(actualLocation.getLocationGroup());
        locationGroup.addLocation(actualLocation);
        assertEquals("OK: Group set on location", locationGroup, actualLocation.getLocationGroup());
        assertTrue("OK: Number of locations increased by 1", noLocations + 1 == locationGroup.getLocations().size());

        locationGroup2.addLocation(actualLocation);
        assertEquals("OK: Group set on location", locationGroup2, actualLocation.getLocationGroup());
        assertTrue("OK: Number of locations decreased by 1", noLocations == locationGroup.getLocations().size());
    }
}
